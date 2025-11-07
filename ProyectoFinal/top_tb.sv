`timescale 1ns / 1ps
module top_tb;
    
    // Señales del testbench
    logic clk;
    logic reset;
    
    // Señales internas 
    logic [31:0] PC;
    logic [31:0] Instr;
    logic [31:0] WriteData, ReadData;
    logic [31:0] DataAdr;
    logic MemWrite;
    
    // debug 
    logic [3:0]  ALUFlags_dbg;
    logic        RegWrite_dbg;
    logic        ALUSrc_dbg;
    logic        MemtoReg_dbg;
    logic        PCSrc_dbg;
    logic [1:0]  ALUControl_dbg;
    logic [1:0]  RegSrc_dbg;
    logic [1:0]  ImmSrc_dbg;
    
    // ARM processor 
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
    
    //Instruction Memory 
    rom_i imem(
        .address(PC[7:2]),
        .q(Instr)
    );
    
    // Data Memory (RAM)
    ram dmem(
        .address(DataAdr[7:2]),
        .clock(clk),
        .data(WriteData),
        .wren(MemWrite),
        .q(ReadData)
    );
    
    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test 
    initial begin
        $display("ARM Processor Test - Iniciando");
        
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        #200;  
        
        $display("Test Finalizado");
        $display("PC final = %h", PC);
        
        $finish;
    end
    
    always @(posedge clk) begin
        if (!reset) begin
        
            $display("----------------------------------------");
            $display("PC=%04h | Instr=%08h | MW=%b | WD=%08h | RD=%08h",
                     PC[15:0], Instr, MemWrite, 
							WriteData, ReadData);
            $display("ALUFlags [N Z C V] = %b", ALUFlags_dbg);
            $display("RegWrite=%b  ALUSrc=%b  MemtoReg=%b  PCSrc=%b  ALUControl=%b  RegSrc=%b  ImmSrc=%b",
                     RegWrite_dbg, ALUSrc_dbg, MemtoReg_dbg, PCSrc_dbg,
                     ALUControl_dbg, RegSrc_dbg, ImmSrc_dbg);
            $display("R0..R7 : %08h %08h %08h %08h %08h %08h %08h %08h",
                     arm_inst.dp.rf.rf[0], arm_inst.dp.rf.rf[1],
                     arm_inst.dp.rf.rf[2], arm_inst.dp.rf.rf[3],
                     arm_inst.dp.rf.rf[4], arm_inst.dp.rf.rf[5],
                     arm_inst.dp.rf.rf[6], arm_inst.dp.rf.rf[7]);
        end
    end
    
endmodule