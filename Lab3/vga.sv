module vga(
    input  logic clk,
    input  logic reset,
    input  logic btn_up_n,
    input  logic btn_down_n,
    input  logic btn_left_n,
    input  logic btn_right_n,

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

    // Señales de la FSM
    logic clr_timers, start_timer, init_board, t15s_expired;
    logic clr_score, random_enable, board_write, show_7seg, scan_buttons;
    logic random_pick, flip_sel_card, store_sel_card, compare_enable;
    logic lock_pair, inc_score, short_delay, hide_cards, display_winner;
    logic shuffle_done;
    logic [3:0] board [0:15];

    // Reloj VGA
    pll vgapll(.inclk0(clk), .c0(vgaclk));

    vgaController vgaCont(
        .vgaclk(vgaclk),
        .hsync(hsync), .vsync(vsync),
        .sync_b(sync_b), .blank_b(blank_b),
        .x(x), .y(y)
    );

    
    logic p_up, p_down, p_left, p_right;

    btn_debounced_pulse db_up    (.clk(clk), .rst(reset), .btn_n(btn_up_n),    .pulse(p_up));
    btn_debounced_pulse db_down  (.clk(clk), .rst(reset), .btn_n(btn_down_n),  .pulse(p_down));
    btn_debounced_pulse db_left  (.clk(clk), .rst(reset), .btn_n(btn_left_n),  .pulse(p_left));
    btn_debounced_pulse db_right (.clk(clk), .rst(reset), .btn_n(btn_right_n), .pulse(p_right));

    
    logic [1:0] sel_row, sel_col;
    logic [5:0] sel_idx;

    cursor_4x4 u_cursor (
        .clk(clk),
        .rst(reset),
        .enable(1'b1), 
        .up_pulse(p_up),
        .down_pulse(p_down),
        .left_pulse(p_left),
        .right_pulse(p_right),
        .sel_row(sel_row),
        .sel_col(sel_col),
        .sel_idx(sel_idx)
    );

    
    videoGen videoGen_inst (
        .x(x), .y(y),
        .board(board),
        .sel_row(sel_row),
        .sel_col(sel_col),
        .r(r), .g(g), .b(b)
    );

    // FSM 
    controladora_FSM fsm (
        .clk(clk),
        .rst(reset),
        .shuffle_done(shuffle_done),
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
        .clk     (clk),
        .reset   (clr_timers),
        .start   (start_timer),
        .expired (t15s_expired),
        .seg_tens(seg_tens),
        .seg_ones(seg_ones)
    );

    shuffle shh (
        .clk(clk),
        .rst(reset),
        .init_board(init_board),
        .start(random_enable),
        .init(4'b1011),
        .done(shuffle_done),
        .board(board)
    );

endmodule
