`timescale 1ns / 1ps

module top_tb;
    
    logic clk;
    logic reset;
    
    // Señales internas entre ARM y memorias
    logic [31:0] PC;
    logic [31:0] Instr;
    logic [31:0] WriteData, ReadData;
    logic [31:0] DataAdr;
    logic        MemWrite;
    
    // debug desde el ARM
    logic [3:0]  ALUFlags_dbg;
    logic        RegWrite_dbg;
    logic        ALUSrc_dbg;
    logic        MemtoReg_dbg;
    logic        PCSrc_dbg;
    logic [1:0]  ALUControl_dbg;
    logic [1:0]  RegSrc_dbg;
    logic [1:0]  ImmSrc_dbg;
    
    arm arm_inst(
        .clk       (clk),
        .reset     (reset),
        .PC        (PC),
        .Instr     (Instr),
        .MemWrite  (MemWrite),
        .ALUResult (DataAdr),
        .WriteData (WriteData),
        .ReadData  (ReadData),
        // debug
        .ALUFlags  (ALUFlags_dbg),
        .RegWrite  (RegWrite_dbg),
        .ALUSrc    (ALUSrc_dbg),
        .MemtoReg  (MemtoReg_dbg),
        .PCSrc     (PCSrc_dbg),
        .ALUControl(ALUControl_dbg),
        .RegSrc    (RegSrc_dbg),
        .ImmSrc    (ImmSrc_dbg)
    );
    
    rom_i imem(
        .address(PC[8:2]),  
        .q      (Instr)
    );

    // Memoria de datos (RAM)
    // Puerto A: CPU, Puerto B:
    logic [2:0]  cpu_word_addr;
    logic [2:0]  vga_word_addr_dummy;
    logic [31:0] ram_q_a;
    logic [31:0] ram_q_b_dummy;

    assign cpu_word_addr       = DataAdr[4:2]; // 8 palabras = 3 bits
    assign vga_word_addr_dummy = 3'd0;

    ram dmem(
        .address_a (cpu_word_addr),
        .address_b (vga_word_addr_dummy),
        .clock     (clk),           
        .data_a    (WriteData),
        .data_b    (32'b0),         
        .wren_a    (MemWrite),      
        .wren_b    (1'b0),
        .q_a       (ram_q_a),
        .q_b       (ram_q_b_dummy)
    );

    assign ReadData = ram_q_a;
    
    // Generación de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // periodo 10 ns
    end
    
    // Secuencia de reset y tiempo de simulación
    initial begin
        $display("ARM Processor Test - Iniciando");
        
        reset = 1;
        @(posedge clk);
        reset = 0;
        
        // tiempo de simulación
        #200;
        
        $display("Test Finalizado");
        $display("PC final = %h", PC);
        
        $finish;
    end
    
    // Monitoreo
    always @(posedge clk) begin
        if (!reset) begin
            $display("----------------------------------------");
            $display("PC=%04h | Instr=%08h | MW=%b | WD=%08h | RD=%08h | DataAdr=%08h",
                     PC[15:0], Instr, MemWrite, WriteData, ReadData, DataAdr);
            $display("RegWrite=%b  ALUSrc=%b  MemtoReg=%b  PCSrc=%b  ALUControl=%b  RegSrc=%b  ImmSrc=%b",
                     RegWrite_dbg, ALUSrc_dbg, MemtoReg_dbg, PCSrc_dbg,
                     ALUControl_dbg, RegSrc_dbg, ImmSrc_dbg);
            $display("r0..r7  : %08h %08h %08h %08h %08h %08h %08h %08h",
                     arm_inst.dp.rf.rf[0], arm_inst.dp.rf.rf[1],
                     arm_inst.dp.rf.rf[2], arm_inst.dp.rf.rf[3],
                     arm_inst.dp.rf.rf[4], arm_inst.dp.rf.rf[5],
                     arm_inst.dp.rf.rf[6], arm_inst.dp.rf.rf[7]);
            $display("r8..r14 : %08h %08h %08h %08h %08h %08h %08h",
                     arm_inst.dp.rf.rf[8], arm_inst.dp.rf.rf[9],
                     arm_inst.dp.rf.rf[10], arm_inst.dp.rf.rf[11],
                     arm_inst.dp.rf.rf[12], arm_inst.dp.rf.rf[13],
                     arm_inst.dp.rf.rf[14]);
        end
    end
    
endmodule
