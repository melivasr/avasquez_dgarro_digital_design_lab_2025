module fsm(
	input logic rst,
	input logic clk,
	input logic timer_flag,
	input logic btn,
	
	output logic led_g_vh,
	output logic led_y_vh,
	output logic led_r_vh,
	output logic led_g_p,
	output logic led_r_p,
	output logic [3:0] timer
);
	typedef enum logic [1:0]{
		INIT = 2'b00,
		VEHICULAR = 2'b01,
		PEATONAL = 2'b10
	}t_state;
	
	t_state state, next_state;
	
	always_ff@(posedge clk or posedge rst) begin
		if(rst) state <= INIT;
		else state <= next_state;
	end
	
	always_comb begin
		next_state = state;
		case (state)
			INIT: begin
				if (timer_flag)
					next_state = VEHICULAR;
				else
					next_state = INIT;
			end
			VEHICULAR: begin
				if (timer_flag)
					next_state = PEATONAL;
				else if (btn)
					next_state = PEATONAL;
				else
					next_state = VEHICULAR;
			end
			PEATONAL: begin
				if (timer_flag)
					next_state = INIT;
				else
					next_state = PEATONAL;
			end
			default : next_state = INIT;
		endcase
	end
	
	always_comb begin
		led_g_vh = 0;
		led_y_vh = 0;
		led_r_vh = 0;
		led_g_p = 0;
		led_r_p = 0;
		timer = 0;
		case (state)
			INIT: begin
				led_y_vh = 1;
				led_r_p = 1;
				timer = 4'd3;
			end
			VEHICULAR: begin
				led_g_vh = 1;
				led_r_p = 1;
				timer = 4'd10;
			end
			PEATONAL: begin
				led_r_vh = 1;
				led_g_p = 1;
				timer = 4'd5;
			end
		endcase
	end
	
endmodule