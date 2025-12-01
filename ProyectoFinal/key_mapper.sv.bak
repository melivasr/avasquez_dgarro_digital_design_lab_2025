module key_mapper (
    input  logic        clk,
    input  logic        reset,
    input  logic [15:0] ps2_hex,   // {byte_anterior, byte_actual}
    output logic [3:0]  keys       
);

    logic p1_up, p1_down, p2_up, p2_down;

    wire [7:0] hi = ps2_hex[15:8];
    wire [7:0] lo = ps2_hex[7:0];

    wire is_break = (hi == 8'hF0);  // F0 = break
    wire [7:0] code = lo;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            p1_up   <= 1'b0;
            p1_down <= 1'b0;
            p2_up   <= 1'b0;
            p2_down <= 1'b0;
        end else begin
            case (code)
                8'h2D: begin  // R = P1 UP
                    if (is_break) p1_up <= 1'b0;
                    else          p1_up <= 1'b1;
                end
                8'h2B: begin  // F = P1 DOWN
                    if (is_break) p1_down <= 1'b0;
                    else          p1_down <= 1'b1;
                end
                8'h44: begin  // O = P2 UP
                    if (is_break) p2_up <= 1'b0;
                    else          p2_up <= 1'b1;
                end
                8'h4B: begin  // L = P2 DOWN
                    if (is_break) p2_down <= 1'b0;
                    else          p2_down <= 1'b1;
                end
                default: begin
                    // otras teclas: no cambiar nada
                end
            endcase
        end
    end

    always_comb begin
        keys = {p2_down, p2_up, p1_down, p1_up};
    end

endmodule
