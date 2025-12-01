module semaforo(
	input logic clk,
	input logic rst,
	input logic btn,
	
	output logic led_g_vh,
	output logic led_y_vh,
	output logic led_r_vh,
	output logic led_g_p,
	output logic led_r_p
);
	
	logic [3:0] timer;
	logic timer_flag;
	
	
	fsm fsm_u(
		.rst(rst),
		.clk(clk),
		.timer_flag(timer_flag),
		.btn(btn),
		.led_g_vh(led_g_vh),
		.led_y_vh(led_y_vh),
		.led_r_vh(led_r_vh),
		.led_g_p(led_g_p),
		.led_r_p(led_r_p),
		.timer(timer)
	);
	
	time_counter time_counter_u(
     .clk(clk),
     .reset(rst),
     .timer(timer),       
     .timer_flag(timer_flag)     
);

endmodule