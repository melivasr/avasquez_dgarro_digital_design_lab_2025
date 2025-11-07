module top(
    input logic clk,
    input logic reset
);
    // Señales internas
    logic [31:0] PC;
    logic [31:0] Instr;
    logic [31:0] WriteData, ReadData;
    logic [31:0] DataAdr;
    logic MemWrite;

    //debug signals
    logic [3:0]  ALUFlags_dbg;
    logic        RegWrite_dbg;
    logic        ALUSrc_dbg;
    logic        MemtoReg_dbg;
    logic        PCSrc_dbg;
    logic [1:0]  ALUControl_dbg;
    logic [1:0]  RegSrc_dbg;
    logic [1:0]  ImmSrc_dbg;

    // Instantiate ARM processor
    arm arm_inst(
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .MemWrite(MemWrite),
        .ALUResult(DataAdr),
        .WriteData(WriteData),
        .ReadData(ReadData),
        // debug
        .ALUFlags(ALUFlags_dbg),
        .RegWrite(RegWrite_dbg),
        .ALUSrc(ALUSrc_dbg),
        .MemtoReg(MemtoReg_dbg),
        .PCSrc(PCSrc_dbg),
        .ALUControl(ALUControl_dbg),
        .RegSrc(RegSrc_dbg),
        .ImmSrc(ImmSrc_dbg)
    );

    // Instantiate Instruction Memory (ROM)
    rom_i imem(
        .address(PC[7:2]),
        .q(Instr)
    );

    // Instantiate Data Memory (RAM)
    ram dmem(
        .address(DataAdr[7:2]),
        .clock(clk),
        .data(WriteData),
        .wren(MemWrite),
        .q(ReadData)
    );

endmodule
