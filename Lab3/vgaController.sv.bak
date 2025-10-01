module vgaController (input logic vgaclk,
	output logic hsync, vsync, sync_b, blank_b,
	output logic [9:0] x, y);
	
	parameter HACTIVE = 10'd640;
	parameter HFP = 10'd16;
	parameter HSYN = 10'd96;
	parameter HBP = 10'd48;
	parameter HMAX = HACTIVE + HFP + HSYN + HBP;
	parameter VBP = 10'd32;
	parameter VACTIVE = 10'd480;
	parameter VFP = 10'd11;
	parameter VSYN = 10'd2;
	parameter VMAX = VACTIVE + VFP + VSYN + VBP;
	
	// counters for horizontal and vertical positions
	always @(posedge vgaclk) begin
		x++;
		if (x == HMAX) begin
			x = 0;
			y++;
			if (y == VMAX) 
				y = 0;
			end
		end
		
	// Compute sync signals (active low)
	assign hsync = ~(x >= HACTIVE + HFP & x < HACTIVE + HFP + HSYN);
	assign vsync = ~(y >= VACTIVE + VFP & y < VACTIVE + VFP + VSYN);
	assign sync_b = hsync & vsync;

	// Force outputs to black when outside the legal display area
	assign blank_b = (x < HACTIVE) & (y < VACTIVE);
endmodule