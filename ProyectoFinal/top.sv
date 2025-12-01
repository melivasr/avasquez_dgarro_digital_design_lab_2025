module top(
    input logic clk,
    input logic reset,
	 
	  // PS2
    input  logic PS2_KBCLK,
    input  logic PS2_KBDAT,
    // VGA
    output logic vgaclk,
    output logic hsync, vsync,
    output logic sync_b, blank_b,
    output logic [7:0] r, g, b
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
        .clk(vgaclk),
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
		 .address(PC[9:2]),   // 8 bits, hasta 256 palabras
		 .q(Instr)
	);

    //RAM de datos 2-PORT
    logic [31:0] ram_q_a;  //para ARM
    logic [31:0] ram_q_b;  //para VGA
    logic [2:0]  cpu_word_addr;
    logic [2:0]  vga_word_addr;

    assign cpu_word_addr = DataAdr[4:2];

    ram dmem(
        .address_a (cpu_word_addr),
        .address_b (vga_word_addr),
        .clock     (vgaclk),
        .data_a    (WriteData),
        .data_b    (32'b0),    // VGA solo lee
        .wren_a    (MemWrite), // ARM escribe
        .wren_b    (1'b0),
        .q_a       (ram_q_a),
        .q_b       (ram_q_b)
    );
	 
	 // reloj y coordenadas VGA
    logic [9:0] x, y;
    pll vgapll(.inclk0(clk), .c0(vgaclk));
	 
    vgaController vgaCont(
        .vgaclk(vgaclk),
        .hsync(hsync), .vsync(vsync),
        .sync_b(sync_b), .blank_b(blank_b),
        .x(x), .y(y)
    );
	 
	  // PS/2
    logic [15:0] ps2_hex;
    logic [3:0]  keys_bits;

    ps2 kb_inst (
        .PS2_KBCLK   (PS2_KBCLK),
        .PS2_KBDAT   (PS2_KBDAT),
        .rst_n       (~reset),
        .computerClk (vgaclk),
        .hexo        (ps2_hex)
    );

    // Decodificador de teclas R/F/O/L
    key_mapper keymap_inst (
        .clk    (vgaclk),
        .reset  (reset),
        .ps2_hex(ps2_hex),
        .keys   (keys_bits)
    );

    // Registro de teclas visto por el ARM:
    // bit0: plyer 1 up (R)
    // bit1: player 1 down (F)
    // bit2: player 2 up  (O)
    // bit3: player 3 down (L)
    wire [31:0] keys_reg = {28'b0, keys_bits};

	 
    // Mux de lectura para el ARM:
    logic [31:0] read_mux;

    always_comb begin
        read_mux = ram_q_a;
        if (cpu_word_addr == 3'd7) begin
            read_mux = keys_reg;
        end
    end

    assign ReadData = read_mux;

	 // Bridge RAM->VGA
    logic [9:0] paddle1_y_vga, paddle2_y_vga;
    logic [9:0] ball_x_vga, ball_y_vga;
    logic [3:0] score1_vga, score2_vga;
	 logic [1:0] winner_vga;

	 ram2vga_bridge u_bridge (
		 .clk      (vgaclk),
		 .reset    (reset),
		 .x        (x),
		 .y        (y),
		 .addr_b   (vga_word_addr),
		 .q_b      (ram_q_b),
		 .paddle1_y(paddle1_y_vga),
		 .paddle2_y(paddle2_y_vga),
		 .ball_x   (ball_x_vga),
		 .ball_y   (ball_y_vga),
		 .score1   (score1_vga),
		 .score2   (score2_vga),
		 .winner   (winner_vga)
	 );


    // VideoGen
    videoGen_pong u_video (
        .x(x),
        .y(y),
        .paddle1_y(paddle1_y_vga),
        .paddle2_y(paddle2_y_vga),
        .ball_x   (ball_x_vga),
        .ball_y   (ball_y_vga),
        .score1   (score1_vga),
        .score2   (score2_vga),
		  .winner   (winner_vga),
        .r(r),
        .g(g),
        .b(b)
    );

endmodule
