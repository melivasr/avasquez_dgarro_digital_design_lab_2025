module vga(
    input  logic clk,
	 input  logic reset,
    output logic vgaclk,
    output logic hsync, vsync,
    output logic sync_b, blank_b,
    output logic [7:0] r, g, b,
	 output logic [6:0] seg_tens, 
    output logic [6:0] seg_ones 
);
    logic [9:0] x, y;

    pll vgapll(.inclk0(clk), .c0(vgaclk));

    vgaController vgaCont(
        .vgaclk(vgaclk),
        .hsync(hsync), .vsync(vsync),
        .sync_b(sync_b), .blank_b(blank_b),
        .x(x), .y(y)
    );

    videoGen videoGen_inst (
        .x(x), .y(y),
        .r(r), .g(g), .b(b)
    );
	 timer15_7seg u_turn_timer (
			.clk(clk),
			.reset(reset),
			.seg_tens(seg_tens),
			.seg_ones(seg_ones)
	 );

endmodule