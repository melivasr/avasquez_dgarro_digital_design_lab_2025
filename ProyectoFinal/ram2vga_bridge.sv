module ram2vga_bridge (
    input  logic        clk,
    input  logic        reset,

    // Puerto B de la RAM
    output logic [2:0]  addr_b,
    input  logic [31:0] q_b,

    // Salidas para VGA
    output logic [9:0]  paddle1_y,
    output logic [9:0]  paddle2_y,
    output logic [9:0]  ball_x,
    output logic [9:0]  ball_y,
    output logic [3:0]  score1,
    output logic [3:0]  score2,
    output logic [1:0]  winner
);

    logic [31:0] paddle1_y_reg, paddle2_y_reg;
    logic [31:0] ball_x_reg,    ball_y_reg;
    logic [31:0] score1_reg,    score2_reg;
    logic [31:0] winner_reg; 

    typedef enum logic [2:0] {R_P1Y, R_P2Y, R_BX, R_BY, R_S1, R_S2, R_WIN} vga_read_state_t;
    vga_read_state_t state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= R_P1Y;
            addr_b  <= 3'd0;
            paddle1_y_reg <= 32'd0;
            paddle2_y_reg <= 32'd0;
            ball_x_reg <= 32'd0;
            ball_y_reg <= 32'd0;
            score1_reg <= 32'd0;
            score2_reg <= 32'd0;
            winner_reg <= 32'd0;
        end else begin
            case (state)
                R_P1Y: begin
                    paddle1_y_reg <= q_b;
                    addr_b <= 3'd1; // P2_Y
                    state <= R_P2Y;
                end
                R_P2Y: begin
                    paddle2_y_reg <= q_b;
                    addr_b  <= 3'd2; // BALL_X
                    state <= R_BX;
                end
                R_BX: begin
                    ball_x_reg <= q_b;
                    addr_b <= 3'd3;    // BALL_Y
                    state <= R_BY;
                end
                R_BY: begin
                    ball_y_reg <= q_b;
                    addr_b <= 3'd4;    // SCORE1
                    state <= R_S1;
                end
                R_S1: begin
                    score1_reg <= q_b;
                    addr_b <= 3'd5;    // SCORE2
                    state <= R_S2;
                end
                R_S2: begin
                    score2_reg <= q_b;
                    addr_b <= 3'd6;    // WINNER
                    state <= R_WIN;
                end
                R_WIN: begin
                    winner_reg <= q_b;
                    addr_b  <= 3'd0;    // volver a P1Y
                    state  <= R_P1Y;
                end
            endcase
        end
    end

    always_comb begin
        paddle1_y = paddle1_y_reg[9:0];
        paddle2_y = paddle2_y_reg[9:0];
        ball_x    = ball_x_reg[9:0];
        ball_y    = ball_y_reg[9:0];
        score1    = score1_reg[3:0];
        score2    = score2_reg[3:0];
        winner    = winner_reg[1:0];  
    end
endmodule
