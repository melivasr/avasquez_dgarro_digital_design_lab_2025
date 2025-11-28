module arm(
    input  logic         clk,
    input  logic         reset,
    output logic [31:0]  PC,
    input  logic [31:0]   Instr,
    output logic         MemWrite,
    output logic [31:0]  ALUResult,
    output logic [31:0]  WriteData,
    input  logic [31:0]   ReadData,

    output logic [3:0]   ALUFlags,
    output logic         RegWrite,
    output logic         ALUSrc,
    output logic         MemtoReg,
    output logic         PCSrc,
    output logic [1:0]   ALUControl,
    output logic [1:0]   RegSrc,
    output logic [1:0]   ImmSrc
);

 logic Link;
 
 controller c(clk,reset,Instr[31:12],ALUFlags, RegSrc,RegWrite,ImmSrc,
 ALUSrc,ALUControl,
 MemWrite,MemtoReg,PCSrc, Link);
 
 datapath dp(clk,reset, RegSrc,RegWrite,ImmSrc,
 ALUSrc,ALUControl,
 MemtoReg,PCSrc,
 ALUFlags,PC,Instr,
 ALUResult,WriteData,ReadData, Link);
 
 endmodule