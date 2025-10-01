module videoGen (
    input  logic [9:0] x,
    input  logic [9:0] y,
    output logic [7:0] r, g, b
);
    localparam int CARD_W = 160;
    localparam int CARD_H = 120;
    localparam int BORDER = 3;

    //indices y coords locales
    wire [1:0] col = x / CARD_W;      
    wire [1:0] row = y / CARD_H;      
    wire [8:0] lx  = x % CARD_W;      
    wire [6:0] ly  = y % CARD_H;      

    // 8 simbolos
    wire [2:0] pair_id = ((row * 4) + col) % 8;

    wire in_border = (lx < BORDER) || (lx >= CARD_W - BORDER) ||
                     (ly < BORDER) || (ly >= CARD_H - BORDER);

    localparam int CX = CARD_W/2; // 80
    localparam int CY = CARD_H/2; // 60

    // Coords centradas 
    wire signed [10:0] dx = $signed({1'b0,lx}) - $signed(CX);
    wire signed [10:0] dy = $signed({1'b0,ly}) - $signed(CY);
    wire       [21:0] r2 = dx*dx + dy*dy;

    localparam int THICK   = 4;   // grosor
    localparam int R_CIRC  = 38;  // radio circulo
    localparam int R_DIAM  = 45;  // rombo
    localparam int R_SQ    = 40;  // semilado del cuadrado
    localparam int PLUS_H  = 7;   // semigrosor +
    localparam int TRI_TOP = 20;  
    localparam int TRI_BOT = 100; 

    wire in_circle = (r2 < (R_CIRC*R_CIRC));
    wire in_triangle;
    assign in_triangle = (ly > TRI_TOP) && (ly < TRI_BOT) &&
                         (lx >= (CX - (ly - TRI_TOP))) &&
                         (lx <= (CX + (ly - TRI_TOP)));

    // X con grosor:|dx-dy|
    function automatic [10:0] abs11(input signed [10:0] v);
        abs11 = (v < 0) ? -v : v;
    endfunction
    wire in_crossX = (abs11(dx -dy) <= THICK) || (abs11(dx + dy) <= THICK);

    // Rombo
    wire in_diamond = (abs11(dx) + abs11(dy)) < R_DIAM;

    //+
    wire in_plus = ((lx >= (CX - PLUS_H)) && (lx <= (CX + PLUS_H))) ||
                   ((ly >= (CY - PLUS_H)) && (ly <= (CY + PLUS_H)));

    //Cuadrado
    wire in_square = (lx > CX - R_SQ) && (lx < CX + R_SQ) &&
                     (ly > CY - R_SQ) && (ly < CY + R_SQ);

    //Triangulo invertido 
    wire in_triangle_inv;
    assign in_triangle_inv = (ly > TRI_TOP) && (ly < TRI_BOT) &&
                             (lx >= (CX - (TRI_BOT - ly))) &&
                             (lx <= (CX + (TRI_BOT - ly)));

    // Corazon
    localparam int H_OFF_X = 14;  // separacion horizontal 
    localparam int H_OFF_Y = 10;  // elevacion 
    localparam int H_R     = 20;  // radio 
    wire signed [10:0] dxL = $signed({1'b0,lx}) - $signed(CX - H_OFF_X);
    wire signed [10:0] dxR = $signed({1'b0,lx}) - $signed(CX + H_OFF_X);
    wire signed [10:0] dyH = $signed({1'b0,ly}) - $signed(CY - H_OFF_Y);
    wire [21:0] r2L = dxL*dxL + dyH*dyH;
    wire [21:0] r2R = dxR*dxR + dyH*dyH;

    // Rombo 
    localparam int HEART_DIAM = 34;
    wire in_heart_lower = (ly >= CY - 2) && ((abs11(dx) + (ly - (CY - 2))) < HEART_DIAM);

    wire in_heart = ( (r2L < (H_R*H_R)) || (r2R < (H_R*H_R)) || in_heart_lower );

    wire in_symbol =
        (pair_id==3'd0) ? in_circle   :
        (pair_id==3'd1) ? in_triangle :
        (pair_id==3'd2) ? in_crossX   :
        (pair_id==3'd3) ? in_diamond  :
        (pair_id==3'd4) ? in_plus     :
        (pair_id==3'd5) ? in_square   :
        (pair_id==3'd6) ? in_triangle_inv  :
                          in_heart;
 
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

    // Fondo y borde de carta
    logic [7:0] br, bg, bb;
    always_comb begin
        if (in_border) begin
            br = 8'd30;  bg = 8'd30;  bb = 8'd30;
        end else begin
            br = 8'd235; bg = 8'd235; bb = 8'd235;
        end
    end

    // Salida final
    always_comb begin
        if (in_symbol && !in_border) begin
            r = cr; g = cg; b = cb;
        end else begin
            r = br; g = bg; b = bb;
        end
    end
endmodule
