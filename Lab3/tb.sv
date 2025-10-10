`timescale 1ns/1ps

module tb;
	// Señales de entrada
	logic clk;
	logic rst;
	logic shuffle_done;
	logic btn_valid;
	logic t15s_expired;
	logic match;
	logic all_pairs;
	logic delay_done;

	// Señales de salida
	logic clr_timers;
	logic clr_score;
	logic init_board;
	logic random_enable;
	logic board_write;
	logic start_timer;
	logic show_7seg;
	logic scan_buttons;
	logic random_pick;
	logic flip_sel_card;
	logic store_sel_card;
	logic compare_enable;
	logic lock_pair;
	logic inc_score;
	logic short_delay;
	logic hide_cards;
	logic display_winner;
	logic player;
	logic [1:0] sel_count;

	// Instancia FSM
	controladora_FSM dut (
		.clk(clk),
		.rst(rst),
		.shuffle_done(shuffle_done),
		.btn_valid(btn_valid),
		.t15s_expired(t15s_expired),
		.match(match),
		.all_pairs(all_pairs),
		.delay_done(delay_done),
		.clr_timers(clr_timers),
		.clr_score(clr_score),
		.init_board(init_board),
		.random_enable(random_enable),
		.board_write(board_write),
		.start_timer(start_timer),
		.show_7seg(show_7seg),
		.scan_buttons(scan_buttons),
		.random_pick(random_pick),
		.flip_sel_card(flip_sel_card),
		.store_sel_card(store_sel_card),
		.compare_enable(compare_enable),
		.lock_pair(lock_pair),
		.inc_score(inc_score),
		.short_delay(short_delay),
		.hide_cards(hide_cards),
		.display_winner(display_winner),
		.player(player),
		.sel_count(sel_count)
	);

	// Para el reloj
	initial clk = 0;
	always #10 clk = ~clk;


	initial begin
		// Reset
		rst = 1;
		shuffle_done = 0;
		btn_valid = 0;
		t15s_expired = 0;
		match = 0;
		all_pairs = 0;
		delay_done = 0;
		#100;
		rst = 0;

		// S0 -> S1

		// S1 -> S2
		#200 shuffle_done = 1; #40 shuffle_done = 0;

		// S2 -> S3
		
		// S3 -> S4 (con btn_valid)
		#200 btn_valid = 1; #40 btn_valid = 0;
		#200 btn_valid = 1; #40 btn_valid = 0;  

		// S4 -> S6, (con sel_count = 2)
		
		// S6 -> S8, (No hay match)
		
		// Se prueban inputs en otro estado
		#100 match = 1; #40 match = 0;
		#200 btn_valid = 1; #40 btn_valid = 0;
		#200 btn_valid = 1; #40 btn_valid = 0;
		
		// S8 -> S9, (con delay_done = 1)
		#200 delay_done = 1; #40 delay_done = 0;

		// S3 -> S4, (con t15 expired = 1)
		#200 t15s_expired = 1; #40 t15s_expired = 0;

		// S6 -> S7 y luego S7 -> S10
		match = 1;  #40 match = 0;
		all_pairs = 1; #40 all_pairs = 0;

		
		#300 
		$finish;
	end

endmodule