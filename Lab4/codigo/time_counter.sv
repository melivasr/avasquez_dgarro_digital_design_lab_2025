module time_counter(
    input  logic       clk,
    input  logic       reset,
    input  logic [3:0] timer,
	 
    output logic       timer_flag
);

	logic tick;
	logic [3:0] seconds;
	localparam int unsigned CLK_HZ  = 50_000_000;
	localparam int unsigned DIV_MAX = CLK_HZ - 1;
	logic [$clog2(CLK_HZ)-1:0] div_cnt;
	logic tick_1hz;
	
	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			div_cnt  <= '0;
			tick_1hz <= 1'b0;
		end else begin
			if (div_cnt == DIV_MAX) begin
				div_cnt  <= '0;
				tick_1hz <= 1'b1;
			end else begin
				div_cnt  <= div_cnt + 1'b1;
				tick_1hz <= 1'b0;
			end
		end
	end
	
	assign tick = tick_1hz;
	
	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			seconds <= 4'd0;
			timer_flag <= 1'b0;
		end else begin
			timer_flag <= 1'b0;
			if (timer && seconds == 4'd0) begin
				seconds <= timer;
			end else if (tick) begin
				if (seconds != 4'd0) begin
					timer_flag <= (seconds == 4'd1);
					seconds <= seconds - 4'd1;
				end
			end
		end
	end
	
endmodule