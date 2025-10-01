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

  // Instancia del DUT
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

  // Generador de clock
  always #5 clk = ~clk; // 100 MHz

  // Tarea para aplicar un pulso
  task pulse(input logic signal);
    begin
      signal = 1;
      @(posedge clk);
      signal = 0;
    end
  endtask

  // Estímulos
  initial begin
    // Inicialización
    clk = 0;
    rst = 0;
    shuffle_done = 0;
    btn_valid = 0;
    t15s_expired = 0;
    match = 0;
    all_pairs = 0;
    delay_done = 0;

    // Reset
    $display("=== Reset ===");
    rst = 1; @(posedge clk);
    rst = 0; @(posedge clk);

    // Fin del shuffle
    $display("=== Shuffle Done ===");
    shuffle_done = 1; @(posedge clk);
    shuffle_done = 0;

    // Jugada válida
    $display("=== Jugada Válida ===");
    repeat(2) begin
      btn_valid = 1; @(posedge clk);
      btn_valid = 0; @(posedge clk);
    end

    // Simular par correcto
    $display("=== Match ===");
    match = 1; @(posedge clk);
    match = 0; @(posedge clk);

    // Nueva ronda: tiempo agotado -> auto pick
    $display("=== Tiempo Agotado -> Auto Pick ===");
    t15s_expired = 1; @(posedge clk);
    t15s_expired = 0;
    repeat(2) @(posedge clk);

    // No match
    $display("=== Unmatch ===");
    match = 0; @(posedge clk);
    delay_done = 1; @(posedge clk);
    delay_done = 0;

    // Todas las parejas encontradas
    $display("=== Todas las parejas encontradas ===");
    all_pairs = 1;
    match = 1; @(posedge clk);
    match = 0;

    // Fin
    $display("=== Fin de simulación ===");
    repeat(10) @(posedge clk);
    $finish;
  end

  // Monitoreo
  initial begin
    $monitor("T=%0t state=%0d sel_count=%0d player=%0b clr_timers=%b start_timer=%b scan_buttons=%b compare=%b match=%b",
             $time, dut.state, sel_count, player, clr_timers, start_timer, scan_buttons, compare_enable, match);
  end

endmodule
