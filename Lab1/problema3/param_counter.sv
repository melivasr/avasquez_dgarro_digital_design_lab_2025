module param_counter (
    input  logic        clk,
    input  logic        reset_sw,     // reset asíncrono (switch, activo en 1)
    input  logic        inc_btn,      // botón: incrementar
    input  logic        load_btn,     // botón: cargar sw_init
    input  logic [5:0]  sw_init,      // valor inicial 0..63
    output logic [6:0]  seg0,         // unidades (ánodo común: activo en 0)
    output logic [6:0]  seg1          // decenas  (ánodo común: activo en 0)
);
    // --- Sincronización y flancos de botones ---
    logic inc_ff1, inc_ff2, load_ff1, load_ff2;
    always_ff @(posedge clk) begin
        inc_ff1  <= inc_btn;
        inc_ff2  <= inc_ff1;
        load_ff1 <= load_btn;
        load_ff2 <= load_ff1;
    end
    wire inc_pulse  =  inc_ff1 & ~inc_ff2;
    wire load_pulse =  load_ff1 & ~load_ff2;

    // --- Contador 6 bits ---
    logic [5:0] q;
    counter_n #(.N(6)) u_cnt (
        .clk  (clk),
        .arst (reset_sw),
        .en   (inc_pulse),
        .load (load_pulse),
        .d    (sw_init),
        .q    (q)
    );

    // --- Conversión a decimal (usar 7 bits para evitar truncations) ---
    logic [3:0] digit0, digit1;   // unidades y decenas (0..9 y 0..6)
    logic [6:0] val7, tens7, units7;

    always_comb begin
        val7   = {1'b0, q};         // 0..63 en 7 bits
        tens7  = val7 / 7'd10;      // 0..6
        units7 = val7 % 7'd10;      // 0..9
        digit1 = tens7[3:0];        // decenas
        digit0 = units7[3:0];       // unidades
    end

    // --- Decodificador 7 segmentos (a..g = [6:0] activo en 1) ---
    function automatic logic [6:0] seg7(input logic [3:0] x);
        case (x)
            4'h0: seg7 = 7'b1111110;  // a b c d e f g
            4'h1: seg7 = 7'b0110000;
            4'h2: seg7 = 7'b1101101;
            4'h3: seg7 = 7'b1111001;
            4'h4: seg7 = 7'b0110011;
            4'h5: seg7 = 7'b1011011;
            4'h6: seg7 = 7'b1011111;
            4'h7: seg7 = 7'b1110000;
            4'h8: seg7 = 7'b1111111;
            4'h9: seg7 = 7'b1111011;
            default: seg7 = 7'b0000001; // '-'
        endcase
    endfunction

    // --- Reordenamiento para placas donde HEXx[6:0] = g f e d c b a
    //     y ajuste a ánodo común (activo en 0): invertir.
    logic [6:0] r0, r1;            
    assign r0 = seg7(digit0);
    assign r1 = seg7(digit1);

    
    assign seg0 = ~{ r0[0], r0[1], r0[2], r0[3], r0[4], r0[5], r0[6] };  // g f e d c b a
    assign seg1 = ~{ r1[0], r1[1], r1[2], r1[3], r1[4], r1[5], r1[6] };

endmodule
