module vga(
    input  logic clk,
	 input  logic reset,
    output logic vgaclk,
    output logic hsync, vsync,
    output logic sync_b, blank_b,
    output logic [7:0] r, g, b,
	 output logic [6:0] seg_tens, 
    output logic [6:0] seg_ones, 
	 output logic player,
    output logic [1:0] sel_count
);
    logic [9:0] x, y;
	 
	 // Señales para la FSM
	 logic clr_timers, start_timer, t15s_expired;
    logic clr_score, init_board, random_enable, board_write;
    logic show_7seg, scan_buttons, random_pick, flip_sel_card;
    logic store_sel_card, compare_enable, lock_pair, inc_score;
    logic short_delay, hide_cards, display_winner;

	 
	 //Instanciaciones

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
	 
	 
	 controladora_FSM fsm (
        .clk(clk),
        .rst(reset),
        .shuffle_done(1'b0),
        .btn_valid(1'b0),
        .match(1'b0),
        .all_pairs(1'b0),
        .delay_done(1'b0),
        .t15s_expired(t15s_expired),

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

	 
	 timer15_7seg u_turn_timer (
        .clk(clk),
        .reset(clr_timers),
        .start(start_timer),
        .expired(t15s_expired),
        .seg_tens(seg_tens),
        .seg_ones(seg_ones)
    );

endmodule