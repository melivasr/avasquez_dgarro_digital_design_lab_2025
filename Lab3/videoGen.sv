module videoGen (
    input  logic [9:0] x,
    input  logic [9:0] y,
    input  logic [3:0] board [0:15],
    input  logic [1:0] sel_row,
    input  logic [1:0] sel_col,
    input  logic [15:0] reveal_mask,
	 input  logic [15:0] locked_mask,
    output logic [7:0] r, g, b
);
    localparam int SCREEN_W   = 640;
    localparam int SCREEN_H   = 480;
    localparam int GRID_COLS  = 4;
    localparam int GRID_ROWS  = 4;

    localparam int CARD_W = 80;
    localparam int CARD_H = 110;
    localparam int GAP_X  = 12;
    localparam int GAP_Y  = 10;
    localparam int BORDER = 3;

    localparam int TOTAL_W = GRID_COLS*CARD_W + (GRID_COLS-1)*GAP_X; 
    localparam int TOTAL_H = GRID_ROWS*CARD_H + (GRID_ROWS-1)*GAP_Y; 

    localparam int MARGIN_X = (SCREEN_W - TOTAL_W)/2;
    localparam int MARGIN_Y = (SCREEN_H - TOTAL_H)/2;

    // mesa
    localparam logic [7:0] TABLE_R = 8'd20;
    localparam logic [7:0] TABLE_G = 8'd90;
    localparam logic [7:0] TABLE_B = 8'd20;

    // dorso
    localparam logic [7:0] BACK_R = 8'd50;
    localparam logic [7:0] BACK_G = 8'd50;
    localparam logic [7:0] BACK_B = 8'd140;

    
    localparam signed [10:0] MX  = MARGIN_X;
    localparam signed [10:0] MY  = MARGIN_Y;

    // coords relativas
    wire signed [10:0] rx = $signed({1'b0,x}) - MX;
    wire signed [10:0] ry = $signed({1'b0,y}) - MY;

    localparam int CELL_W = CARD_W + GAP_X;
    localparam int CELL_H = CARD_H + GAP_Y;

    wire outside_grid = (rx < 0) || (ry < 0) ||
                        (rx >= TOTAL_W) || (ry >= TOTAL_H);

    wire [9:0] rx_u = outside_grid ? 10'd0 : rx[9:0];
    wire [9:0] ry_u = outside_grid ? 10'd0 : ry[9:0];

    wire [1:0] col_cell = rx_u / CELL_W;
    wire [1:0] row_cell = ry_u / CELL_H;
    wire [9:0] x_incell = rx_u % CELL_W;
    wire [9:0] y_incell = ry_u % CELL_H;

    wire in_card_x = (col_cell < GRID_COLS) && (x_incell < CARD_W);
    wire in_card_y = (row_cell < GRID_ROWS) && (y_incell < CARD_H);
    wire in_card   = !outside_grid && in_card_x && in_card_y;

    wire [9:0] lx = in_card ? x_incell : 10'd0;
    wire [9:0] ly = in_card ? y_incell : 10'd0;

    wire [1:0] col = col_cell;
    wire [1:0] row = row_cell;

    wire [5:0] idx = row * GRID_COLS + col; 
    wire [2:0] pair_id = board[idx][2:0];

    
    wire revealed = reveal_mask[idx];
	 wire locked   = locked_mask[idx];                
    wire temp_sel = reveal_mask[idx] & ~locked;  

    // borde y selección
    wire in_border = in_card &&
                     ((lx < BORDER) || (lx >= CARD_W - BORDER) ||
                      (ly < BORDER) || (ly >= CARD_H - BORDER));

    wire is_selected_cell = in_card && (row == sel_row) && (col == sel_col);

    localparam int CX = CARD_W/2;
    localparam int CY = CARD_H/2;

    // también fijamos ancho/signed para centros y offsets
    localparam signed [10:0] CX11 = CX;
    localparam signed [10:0] CY11 = CY;

    function automatic [10:0] abs11(input signed [10:0] v);
        abs11 = (v < 0) ? -v : v;
    endfunction

    localparam int MIN_SIDE = (CARD_W < CARD_H) ? CARD_W : CARD_H;
    localparam int THICK    = (CARD_W/10 < 2) ? 2 : (CARD_W/10);
    localparam int R_CIRC   = (MIN_SIDE*2)/10;
    localparam int R_DIAM   = (MIN_SIDE*35)/100;
    localparam int R_SQ     = (MIN_SIDE*28)/100;
    localparam int PLUS_H   = (CARD_W*12)/100;

    localparam int TRI_TOP  = (CARD_H*20)/100;
    localparam int TRI_BOT  = (CARD_H*85)/100;

    // distancias al centro
    wire signed [10:0] dx = $signed({1'b0,lx}) - CX11;
    wire signed [10:0] dy = $signed({1'b0,ly}) - CY11;

    wire [21:0] r2 = dx*dx + dy*dy;
    wire in_circle  = (r2 < (R_CIRC*R_CIRC));

    wire in_triangle =
        (ly > TRI_TOP) && (ly < TRI_BOT) &&
        (lx >= (CX - (ly - TRI_TOP))) &&
        (lx <= (CX + (ly - TRI_TOP)));

    wire in_crossX = (abs11(dx - dy) <= THICK) || (abs11(dx + dy) <= THICK);
    wire in_diamond = (abs11(dx) + abs11(dy)) < R_DIAM;

    wire in_plus =
        ((lx >= (CX - PLUS_H)) && (lx <= (CX + PLUS_H))) ||
        ((ly >= (CY - PLUS_H)) && (ly <= (CY + PLUS_H)));

    wire in_square =
        (lx > CX - R_SQ) && (lx < CX + R_SQ) &&
        (ly > CY - R_SQ) && (ly < CY + R_SQ);

    wire in_triangle_inv =
        (ly > TRI_TOP) && (ly < TRI_BOT) &&
        (lx >= (CX - (TRI_BOT - ly))) &&
        (lx <= (CX + (TRI_BOT - ly)));

    // offsets para el corazón (todo con ancho fijo)
    localparam int H_OFF_X = (CARD_W*18)/100;
    localparam int H_OFF_Y = (CARD_H*10)/100;
    localparam int H_R_INT = (MIN_SIDE*22)/100;
    localparam signed [10:0] CXm = CX - H_OFF_X; // centro izquierdo
    localparam signed [10:0] CXp = CX + H_OFF_X; // centro derecho
    localparam signed [10:0] CYm = CY - H_OFF_Y; // centro vertical

    wire signed [10:0] dxL = $signed({1'b0,lx}) - CXm;
    wire signed [10:0] dxR = $signed({1'b0,lx}) - CXp;
    wire signed [10:0] dyH = $signed({1'b0,ly}) - CYm;

    wire [21:0] r2L = dxL*dxL + dyH*dyH;
    wire [21:0] r2R = dxR*dxR + dyH*dyH;

    localparam int HEART_DIAM = (MIN_SIDE*37)/100;
    wire in_heart_lower = (ly >= CY - 2) &&
                          ((abs11(dx) + (ly - (CY - 2))) < HEART_DIAM);
    wire in_heart = ( (r2L < (H_R_INT*H_R_INT)) || (r2R < (H_R_INT*H_R_INT)) || in_heart_lower );

    wire in_symbol_raw =
        (pair_id==3'd0) ? in_heart         :
        (pair_id==3'd1) ? in_triangle     :
        (pair_id==3'd2) ? in_crossX       :
        (pair_id==3'd3) ? in_diamond      :
        (pair_id==3'd4) ? in_plus         :
        (pair_id==3'd5) ? in_square       :
        (pair_id==3'd6) ? in_triangle_inv :
                          in_circle;

    // SOLO dibuja símbolo si la carta está revelada
    wire in_symbol = revealed && in_card && !in_border && in_symbol_raw;

    // Colores por símbolo
    logic [7:0] cr, cg, cb;
    always_comb begin
        unique case (pair_id)
            3'd0: begin cr=8'd220; cg=8'd60;  cb=8'd60;  end
            3'd1: begin cr=8'd60;  cg=8'd180; cb=8'd80;  end
            3'd2: begin cr=8'd60;  cg=8'd120; cb=8'd220; end
            3'd3: begin cr=8'd220; cg=8'd180; cb=8'd60;  end
            3'd4: begin cr=8'd200; cg=8'd80;  cb=8'd200; end
            3'd5: begin cr=8'd60;  cg=8'd200; cb=8'd200; end
            3'd6: begin cr=8'd200; cg=8'd140; cb=8'd80;  end
            default: begin cr=8'd160; cg=8'd160; cb=8'd160; end
        endcase
    end

    // Borde/relleno según estado
    logic [7:0] rr, gg, bb;
    always_comb begin
        if (in_symbol) begin
            rr = cr; gg = cg; bb = cb;                 // símbolo
        end else if (in_card) begin
            if (in_border) begin
                if (is_selected_cell) begin
                    rr=8'd255; gg=8'd230; bb=8'd0;     // borde seleccionado
                end else begin
                    rr=8'd35;  gg=8'd35;  bb=8'd35;    // borde normal
                end
            end else begin
                // dorso si oculta, carta clara si revelada
                if (revealed) begin
                    rr=8'd235; gg=8'd235; bb=8'd235;   // cara hacia arriba
                end else begin
                    rr=BACK_R; gg=BACK_G; bb=BACK_B;   // dorso
                end
            end
        end else begin
            rr = TABLE_R; gg = TABLE_G; bb = TABLE_B;  // mesa
        end
    end

    always_comb begin
        r = rr; g = gg; b = bb;
    end
endmodule
