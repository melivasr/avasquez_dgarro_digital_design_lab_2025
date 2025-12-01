module extend(
    input  logic [23:0] Instr,   // bits [23:0] de la instrucción
    input  logic [1:0]  ImmSrc,
    output logic [31:0] ExtImm
);

    // variables internas
    logic [7:0]  imm8;
    logic [3:0]  rot4;
    logic [31:0] imm32;
    logic [4:0]  sh;   // 0..31, sin signo

    always_comb begin
        // Valores por defecto para evitar latches
        imm8   = 8'd0;
        rot4   = 4'd0;
        imm32  = 32'd0;
        sh     = 5'd0;
        ExtImm = 32'd0;

        unique case (ImmSrc)
            // 00: inmediato de data-processing (MOV, ADD, CMP, etc.)
            2'b00: begin
                imm8  = Instr[7:0];     // imm8
                rot4  = Instr[11:8];    // rot (se multiplica por 2)
                imm32 = {24'b0, imm8};  // se coloca en bits bajos

                if (rot4 == 4'b0000) begin
                    // sin rotación
                    ExtImm = imm32;
                end else begin
                    sh = {rot4, 1'b0};      // sh = 2*rot4  (0..30)
                    // ROR(imm32, sh) = (imm32 >> sh) | (imm32 << (32-sh))
                    ExtImm = (imm32 >> sh) | (imm32 << (5'd32 - sh));
                end
            end

            // 01: 12-bit unsigned immediate (LDR/STR [Rn, #imm12])
            2'b01: begin
                ExtImm = {20'b0, Instr[11:0]};
            end

            // 10: 24-bit two's complement shifted branch (B, BL)
            2'b10: begin
                ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00};
            end

            default: begin
                ExtImm = 32'b0;
            end
        endcase
    end

endmodule
