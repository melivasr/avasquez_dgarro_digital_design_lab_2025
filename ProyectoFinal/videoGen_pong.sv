module videoGen_pong (
    input  logic [9:0] x,
    input  logic [9:0] y,

    input  logic [9:0] paddle1_y,
    input  logic [9:0] paddle2_y,
    input  logic [9:0] ball_x,
    input  logic [9:0] ball_y,
    input  logic [6:0] score1,
    input  logic [6:0] score2,
    input  logic [1:0] winner, 

    output logic [7:0] r,
    output logic [7:0] g,
    output logic [7:0] b
);

    //   PARÁMETROS DEL PONG
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

    typedef logic [7:0] byte_t;

    localparam int FONT_W   = 3;
    localparam int FONT_H   = 5;
    localparam int SCALE    = 6;
    localparam int CHAR_W   = FONT_W*SCALE;
    localparam int CHAR_H   = FONT_H*SCALE;
    localparam int CHAR_SP  = SCALE*2;
    localparam int MAX_CHARS = 12;

    // winner flags
    wire display_winner = (winner != 2'd0);
    wire tie            = 1'b0;          
    wire [1:0] winner_num = winner;      

    function automatic logic [2:0] font3x5_row (
        input byte_t ch,
        input int    row
    );
        case (ch)
            "W": case (row)
                    0: font3x5_row = 3'b101;
                    1: font3x5_row = 3'b101;
                    2: font3x5_row = 3'b111; 
                    3: font3x5_row = 3'b111; 
                    4: font3x5_row = 3'b101;
                    default: font3x5_row = 3'b000;
                 endcase
            "I": case (row)
                    0: font3x5_row=3'b111;
                    1: font3x5_row=3'b010;
                    2: font3x5_row=3'b010;
                    3: font3x5_row=3'b010;
                    4: font3x5_row=3'b111;
                    default: font3x5_row=3'b000;
                 endcase
            "N": case (row)
                    0: font3x5_row = 3'b110; 
                    1: font3x5_row = 3'b111; 
                    2: font3x5_row = 3'b111;
                    3: font3x5_row = 3'b101; 
                    4: font3x5_row = 3'b101; 
                    default: font3x5_row = 3'b000;
                 endcase
            "E": case (row)
                    0: font3x5_row=3'b111;
                    1: font3x5_row=3'b110;
                    2: font3x5_row=3'b111;
                    3: font3x5_row=3'b110;
                    4: font3x5_row=3'b111;
                    default: font3x5_row=3'b000;
                 endcase
            "R": case (row)
                    0: font3x5_row=3'b110;
                    1: font3x5_row=3'b101;
                    2: font3x5_row=3'b110;
                    3: font3x5_row=3'b101;
                    4: font3x5_row=3'b101;
                    default: font3x5_row=3'b000;
                 endcase
            "1": case (row)
                    0: font3x5_row=3'b010;
                    1: font3x5_row=3'b110;
                    2: font3x5_row=3'b010;
                    3: font3x5_row=3'b010;
                    4: font3x5_row=3'b111;
                    default: font3x5_row=3'b000;
                 endcase
            "2": case (row)
                    0: font3x5_row=3'b111;
                    1: font3x5_row=3'b001;
                    2: font3x5_row=3'b111;
                    3: font3x5_row=3'b100;
                    4: font3x5_row=3'b111;
                    default: font3x5_row=3'b000;
                 endcase
            " ": font3x5_row = 3'b000;
            default: font3x5_row = 3'b000;
        endcase
    endfunction

    function automatic logic font_pixel_on(
        input byte_t ch,
        input int    px,
        input int    py
    );
        int col = px / SCALE; // 0..2
        int row = py / SCALE; // 0..4
        logic [2:0] rowbits = font3x5_row(ch, row);
        font_pixel_on = rowbits[2 - col];
    endfunction

    // texto del overlay
    byte_t text_buf [0:MAX_CHARS-1];
    int    text_len;

    always_comb begin
        // limpiar buffer
        for (int i = 0; i < MAX_CHARS; i++)
            text_buf[i] = " ";
        text_len = 0;

        if (display_winner) begin
            if (tie) begin
                text_buf[0]="N"; text_buf[1]="O"; text_buf[2]=" ";
                text_buf[3]="W"; text_buf[4]="I"; text_buf[5]="N";
                text_buf[6]="N"; text_buf[7]="E"; text_buf[8]="R";
                text_len = 9;
            end else begin
                // "WINNER 1" o "WINNER 2"
                text_buf[0]="W"; text_buf[1]="I"; text_buf[2]="N";
                text_buf[3]="N"; text_buf[4]="E"; text_buf[5]="R";
                text_buf[6]=" "; 
                text_buf[7]=(winner_num==2) ? "2" : "1";
                text_len = 8;
            end
        end
    end

    // caja del texto
    int TEXT_W_PIX, TEXT_H_PIX, TEXT_X0, TEXT_Y0;
    always_comb begin
        if (text_len > 0) begin
            TEXT_W_PIX = text_len*CHAR_W + (text_len-1)*CHAR_SP;
            TEXT_H_PIX = CHAR_H;
            TEXT_X0    = (SCREEN_W - TEXT_W_PIX)/2;
            TEXT_Y0    = (SCREEN_H - TEXT_H_PIX)/2;
        end else begin
            TEXT_W_PIX = 0;
            TEXT_H_PIX = 0;
            TEXT_X0    = 0;
            TEXT_Y0    = 0;
        end
    end

    // mapeo de (x,y) al carácter
    logic   inside_text_box, txt_on;
    int     ch_idx, px_in_char, py_in_char;
    int     x_rel, y_rel, char_block, char_x0;

    always_comb begin
        inside_text_box = 1'b0;
        txt_on          = 1'b0;
        ch_idx = 0; px_in_char = 0; py_in_char = 0;
        x_rel = 0; y_rel = 0; char_block = 0; char_x0 = 0;

        if (display_winner && text_len > 0) begin
            if (x >= TEXT_X0 && x < TEXT_X0 + TEXT_W_PIX &&
                y >= TEXT_Y0 && y < TEXT_Y0 + TEXT_H_PIX) begin

                inside_text_box = 1'b1;

                x_rel = x - TEXT_X0;
                y_rel = y - TEXT_Y0;

                char_block = CHAR_W + CHAR_SP;
                ch_idx = x_rel / char_block;
                if (ch_idx >= text_len) ch_idx = text_len - 1;

                char_x0    = ch_idx * char_block;
                px_in_char = x_rel - char_x0;  // 0 .. CHAR_W+CHAR_SP-1
                py_in_char = y_rel;
            
                if (px_in_char < CHAR_W)
                    txt_on = font_pixel_on(text_buf[ch_idx], px_in_char, py_in_char);
                else
                    txt_on = 1'b0;
            end
        end
    end

    // colores base
    localparam [7:0] C_BLACK = 8'h00;
    localparam [7:0] C_WHITE = 8'hFF;

    logic [7:0] rr, gg, bb;

    always_comb begin
        if (display_winner && text_len > 0) begin
            // MODO WINNER: fondo negro, texto blanco
            if (inside_text_box && txt_on) begin
                rr = C_WHITE; gg = C_WHITE; bb = C_WHITE;
            end else begin
                rr = C_BLACK; gg = C_BLACK; bb = C_BLACK;
            end
        end else begin
            // MODO JUEGO NORMAL
            rr = 8'd0;
            gg = 8'd0;
            bb = 8'd0;

            // línea central gris
            if (in_center) begin
                rr = 8'd120; gg = 8'd120; bb = 8'd120;
            end
            // paletas verdes
            if (in_p1 || in_p2) begin
                rr = 8'd0;   gg = 8'd255; bb = 8'd0;
            end
            // bola blanca
            if (in_ball) begin
                rr = 8'd255; gg = 8'd255; bb = 8'd255;
            end
        end
    end

    always_comb begin
        r = rr;
        g = gg;
        b = bb;
    end

endmodule
