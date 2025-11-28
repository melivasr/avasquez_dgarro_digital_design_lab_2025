module datapath(
    input  logic        clk,reset,
    input  logic [1:0]  RegSrc,
    input  logic        RegWrite,
    input  logic [1:0]  ImmSrc,
    input  logic        ALUSrc,
    input  logic [1:0]  ALUControl,
    input  logic        MemtoReg,
    input  logic        PCSrc,
    output logic [3:0]  ALUFlags,
    output logic [31:0] PC,
    input  logic [31:0] Instr,
    output logic [31:0] ALUResult,WriteData,
    input  logic [31:0] ReadData,
	 input  logic Link 
);
    logic [31:0] PCNext,PCPlus4,PCPlus8;
    logic [31:0] ExtImm,SrcA, Result; 
    logic [3:0]  RA1,RA2;

    logic        is_mov, is_rsb;
    logic [31:0] SrcA_pre, SrcB_pre;
    logic [31:0] ALU_A, ALU_B;
	
	 // para BL: destino y dato de escritura
    logic [3:0]  WA3;
    logic [31:0] WD3;

    mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder #(32) pcadd1(PC, 32'b100, PCPlus4);
    adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

    // Regfile
    mux2 #(4) ra1mux(Instr[19:16],4'b1111,RegSrc[0],RA1);
    mux2 #(4) ra2mux(Instr[3:0],Instr[15:12],RegSrc[1],RA2);
	 
	 //WA3: si Link, escribir en R14; si no, en Instr[15:12]
    assign WA3 = Link ? 4'd14 : Instr[15:12];
    // WD3: si Link, escribir PC+4; si no, el Result normal
	 mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
    assign WD3 = Link ? PCPlus4 : Result;

    regfile rf(
        .clk (clk),
        .we3 (RegWrite),
        .reset(reset),
        .ra1 (RA1),
        .ra2 (RA2),
        .wa3   (WA3), 
        .wd3   (WD3),
        .r15 (PCPlus8),
        .rd1 (SrcA),
        .rd2 (WriteData)
    );

   
    extend ext(Instr[23:0], ImmSrc, ExtImm);

    // Detectar MOV y RSB
    assign is_mov = (Instr[27:26] == 2'b00) && (Instr[24:21] == 4'b1101); // MOV
    assign is_rsb = (Instr[27:26] == 2'b00) && (Instr[24:21] == 4'b0011); // RSB

    assign SrcA_pre = is_mov ? 32'b0 : SrcA;
    mux2 #(32) srcbmux(WriteData, ExtImm, ALUSrc, SrcB_pre);

    always_comb begin
        if (is_rsb) begin
            // RSB queremos B - A
            ALU_A = SrcB_pre;  // entra como A
            ALU_B = SrcA_pre;  // entra como B
        end else begin
            // Operaciones: A op B
            ALU_A = SrcA_pre;
            ALU_B = SrcB_pre;
        end
    end

    alu alu(
        .A         (ALU_A),
        .B         (ALU_B),
        .ALUControl(ALUControl),
        .ALUResult (ALUResult),
        .ALUFlags  (ALUFlags)
    );

endmodule
