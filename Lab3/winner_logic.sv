module winner_logic(
    input  logic        rst,
    input  logic        display_winner,   
    input  logic [3:0]  score_p0,
    input  logic [3:0]  score_p1,
    output logic        tie,              // 1 si empate
    output logic [1:0]  winner_num        // 1 J1, 2 J2, 0 sin ganador/empate
);
    always_comb begin
        if (!display_winner) begin
            tie        = 1'b0;
            winner_num = 2'd0;
        end else begin
            if (score_p0 == score_p1) begin
                tie        = 1'b1;
                winner_num = 2'd0;
            end else if (score_p0 > score_p1) begin
                tie        = 1'b0;
                winner_num = 2'd1;
            end else begin
                tie        = 1'b0;
                winner_num = 2'd2;
            end
        end
    end
endmodule
