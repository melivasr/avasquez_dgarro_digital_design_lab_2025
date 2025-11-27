module videoGen_pong (
    input  logic [9:0] x,
    input  logic [9:0] y,

    input  logic [9:0] paddle1_y,
    input  logic [9:0] paddle2_y,
    input  logic [9:0] ball_x,
    input  logic [9:0] ball_y,
    input  logic [3:0] score1,
    input  logic [3:0] score2,

    output logic [7:0] r,
    output logic [7:0] g,
    output logic [7:0] b
);
    localparam int SCREEN_W = 640;
    localparam int SCREEN_H = 480;

    localparam int PADDLE_W  = 10;
    localparam int PADDLE_H  = 60;
    localparam int PADDLE1_X = 20;
    localparam int PADDLE2_X = SCREEN_W - 20 - PADDLE_W;

    localparam int BALL_SIZE = 8;
    // paletas
    wire in_p1 = (x >= PADDLE1_X) &&
                 (x <  PADDLE1_X + PADDLE_W) &&
                 (y >= paddle1_y) &&
                 (y <  paddle1_y + PADDLE_H);
    wire in_p2 = (x >= PADDLE2_X) &&
                 (x <  PADDLE2_X + PADDLE_W) &&
                 (y >= paddle2_y) &&
                 (y <  paddle2_y + PADDLE_H);
    // bola
    wire in_ball = (x >= ball_x) &&
                   (x <  ball_x + BALL_SIZE) &&
                   (y >= ball_y) &&
                   (y <  ball_y + BALL_SIZE);
    // línea central punteada
    localparam int CENTER_X = SCREEN_W/2 - 2;
    localparam int CENTER_W = 4;
    localparam int DASH_H   = 10;
    localparam int DASH_GAP = 10;

    wire in_center_x = (x >= CENTER_X) &&
                       (x <  CENTER_X + CENTER_W);
    wire [9:0] y_mod = y % (DASH_H + DASH_GAP);
    wire in_center   = in_center_x && (y_mod < DASH_H);

    always_comb begin
        // fondo negro
        r = 8'd0; g = 8'd0; b = 8'd0;
        if (in_center) begin
            r = 8'd120; g = 8'd120; b = 8'd120;
        end
        if (in_p1 || in_p2) begin
            r = 8'd0;   g = 8'd255; b = 8'd0;   // paletas verdes
        end
        if (in_ball) begin
            r = 8'd255; g = 8'd255; b = 8'd255; // bola blanca
        end
    end
endmodule
