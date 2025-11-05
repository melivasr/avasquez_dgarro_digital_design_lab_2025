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
    
    // Instantiate ARM processor
    arm arm_inst(
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .MemWrite(MemWrite),
        .ALUResult(DataAdr),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );
    
    // Instantiate Instruction Memory (ROM)
    rom imem(
        .address(PC[10:2]),
        .clock(clk),
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