module decoder(
    input  logic [1:0] Op,
    input  logic [5:0] Funct,
    input  logic [3:0] Rd,
    input  logic bit22,        // B (LDRB/STRB)
    input  logic [3:0] mulcode,      // bits[7:4]
    output logic [1:0] FlagW,
    output logic PCS,RegW,MemW,
    output logic MemtoReg,ALUSrc,
    output logic [1:0] ImmSrc,RegSrc,ALUControl,
    output logic Link, 
    output logic ByteOp,
    output logic IsMul
);

    logic [9:0] controls_raw;
    logic Branch,ALUOp;
    logic RegW_int;

    logic is_cmp, is_tst, is_mul;

    assign is_cmp = (Op == 2'b00) && (Funct[4:1] == 4'b1010); // CMP
    assign is_tst = (Op == 2'b00) && (Funct[4:1] == 4'b1000); // TST
    assign Link   = (Op == 2'b10) && Funct[4];

    // usar bit22, no Funct[2] 
    assign ByteOp = (Op == 2'b01) && bit22;                   // LDRB/STRB

    // MUL: op=00, Funct=000000, mulcode=1001
    assign is_mul = (Op == 2'b00) && (Funct == 6'b000000) && (mulcode == 4'b1001);
    assign IsMul  = is_mul;

    // MainDecoder
    always_comb
        casex (Op)
            // Data-processing (immediate / register)
            2'b00: if (Funct[5]) controls_raw = 10'b0000101001; // imm
                   else          controls_raw = 10'b0000001001; // reg
            // LDR
            2'b01: if (Funct[0]) controls_raw = 10'b0001111000;
            // STR
                   else          controls_raw = 10'b1001110100;
            // B / BL
            2'b10: controls_raw = 10'b0110100010;
           
            default: controls_raw = 10'b0000000000;
        endcase

    assign {RegSrc, ImmSrc, ALUSrc, MemtoReg,
            RegW_int, MemW, Branch, ALUOp} = controls_raw;

    // no escribir en CMP/TST
	 assign RegW = (is_cmp || is_tst) ? 1'b0 :
              (Link ? 1'b1 : RegW_int);

    //ALUDecoder 
	  always_comb begin
        if (ALUOp) begin
            unique case (Funct[4:1])
                4'b0100: ALUControl = 2'b00; // ADD
                4'b0010: ALUControl = 2'b01; // SUB
                4'b0011: ALUControl = 2'b01; // RSB
                4'b0000: ALUControl = 2'b10; // AND
                4'b1100: ALUControl = 2'b11; // ORR
                4'b1101: ALUControl = 2'b11; // MOV
                4'b1010: ALUControl = 2'b01; // CMP
                4'b1000: ALUControl = 2'b10; // TST (AND)
                default: ALUControl = 2'b00; // por defecto ADD
            endcase

            // update flags si S=1 (Funct[0])
            FlagW[1] = Funct[0];
            FlagW[0] = Funct[0] &
                       (ALUControl==2'b00 || ALUControl==2'b01);
        end else begin
            ALUControl = 2'b00;
            FlagW      = 2'b00;
        end
    end

    // PC logic
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

endmodule
