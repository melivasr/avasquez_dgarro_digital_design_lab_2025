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
    input  logic        Link, 
    input  logic        IsMul,
    input  logic        ByteOp
);
    logic [31:0] PCNext,PCPlus4,PCPlus8;
    logic [31:0] ExtImm,SrcA, Result; 

    logic [3:0] RA1,RA2;
    logic [3:0] RA1_dp, RA2_dp;

    logic        is_mov, is_rsb;
    logic [31:0] SrcA_pre, SrcB_pre;
    logic [31:0] ALU_A, ALU_B;
    
    // para BL / MUL
    logic [3:0]  WA3;
    logic [31:0] WD3;

    // Shifter
    logic [31:0] ShOut;
    logic [1:0]  sh_type;
    logic [4:0]  sh_amt;

    // PC logic
    mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder #(32) pcadd1(PC, 32'b100, PCPlus4);
    adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);


    mux2 #(4) ra1mux_dp(Instr[19:16], 4'b1111,    RegSrc[0], RA1_dp);
    mux2 #(4) ra2mux_dp(Instr[3:0],   Instr[15:12],RegSrc[1], RA2_dp);

    // Para MUL:
    //   Rm = Instr[3:0]
    //   Rs = Instr[11:8]
    //   Rd = Instr[19:16]
    assign RA1 = IsMul ? Instr[3:0]  : RA1_dp;  // A = Rm
    assign RA2 = IsMul ? Instr[11:8] : RA2_dp;  // B = Rs

    assign WA3 = Link  ? 4'd14 :
                 IsMul ? Instr[19:16] :
                         Instr[15:12];

    // Lector de memoria con ByteOp 

    logic [31:0] ReadData_ext;
    logic [7:0]  ReadByte;
    logic [1:0]  byte_off;

    assign byte_off = ALUResult[1:0]; 

    always_comb begin
        case (byte_off)
            2'b00: ReadByte = ReadData[7:0];
            2'b01: ReadByte = ReadData[15:8];
            2'b10: ReadByte = ReadData[23:16];
            2'b11: ReadByte = ReadData[31:24];
        endcase

        if (ByteOp)
            ReadData_ext = {24'b0, ReadByte}; // zero-extend
        else
            ReadData_ext = ReadData;
    end

    // WD3
    mux2 #(32) resmux(ALUResult, ReadData_ext, MemtoReg, Result);
    assign WD3 = Link ? PCPlus4 : Result;

    // Regfile

    regfile rf(
        .clk   (clk),
        .we3   (RegWrite),
        .reset (reset),
        .ra1   (RA1),
        .ra2   (RA2),
        .wa3   (WA3), 
        .wd3   (WD3),
        .r15   (PCPlus8),
        .rd1   (SrcA),
        .rd2   (WriteData)
    );

    // Inmediato

    extend ext(Instr[23:0], ImmSrc, ExtImm);

    // Detectar MOV y RSB “clásicos”
    assign is_mov = (Instr[27:26] == 2'b00) && (Instr[24:21] == 4'b1101); // MOV
    assign is_rsb = (Instr[27:26] == 2'b00) && (Instr[24:21] == 4'b0011); // RSB

    assign SrcA_pre = is_mov ? 32'b0 : SrcA;

    //Shifter -

    assign sh_type = Instr[6:5];
    assign sh_amt  = Instr[11:7];

    shifter sh(
        .B      (WriteData),
        .Sh     (IsMul ? 2'b00 : sh_type),
        .Shamt5 (IsMul ? 5'd0  : sh_amt),
        .ShOut  (ShOut)
    );

    // B para ALU
    mux2 #(32) srcbmux(ShOut, ExtImm, ALUSrc, SrcB_pre);

    // A/B a la ALU 

    always_comb begin
        if (is_rsb) begin
            // RSB: B - A
            ALU_A = SrcB_pre;
            ALU_B = SrcA_pre;
        end else begin
            // Operaciones normales: A op B
            ALU_A = SrcA_pre;
            ALU_B = SrcB_pre;
        end
    end

    // ALU 

    alu alu(
        .A         (ALU_A),
        .B         (ALU_B),
        .IsMul     (IsMul),
        .ALUControl(ALUControl),
        .ALUResult (ALUResult),
        .ALUFlags  (ALUFlags)
    );

endmodule
