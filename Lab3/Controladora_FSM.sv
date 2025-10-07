module controladora_FSM (
    input  logic clk,
    input  logic rst,
    input  logic shuffle_done,   // Dice si las cartas están barajadas
    input  logic btn_valid,      // Señala que la jugada ingresada es válida
    input  logic t15s_expired,   // Tiempo se agotó 15s
    input  logic match,          // comparación de cartas
    input  logic all_pairs,      // todas las parejas encontradas
    input  logic delay_done,     // Fin del tiempo de espera
    input  logic [1:0] sel_count, //viene de selection_manager

    output logic clr_timers,
    output logic clr_score,
    output logic init_board,
    output logic random_enable,
    output logic board_write,
    output logic start_timer,
    output logic show_7seg,
    output logic scan_buttons,
    output logic random_pick,
    output logic flip_sel_card,
    output logic store_sel_card,
    output logic compare_enable,
    output logic lock_pair,
    output logic inc_score,
    output logic short_delay,
    output logic hide_cards,
    output logic display_winner,
    output logic player       // jugador actual
);

    typedef enum logic [3:0] {
        RESET_INIT    = 4'b0000,
        SHUFFLE       = 4'b0001,
        TURN_START    = 4'b0010,
        WAIT_SELECTION= 4'b0011,
        REVEAL        = 4'b0100,
        AUTO_PICK     = 4'b0101,
        EVALUATE_PAIR = 4'b0110,
        MATCH         = 4'b0111,
        UNMATCH       = 4'b1000,
        HIDE_PAIR     = 4'b1001,
        GAME_OVER     = 4'b1010
    } state_type;

    state_type state, next_state;

    logic player_reg;
    assign player = player_reg;

    // Estado/jugador
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state      <= RESET_INIT;
            player_reg <= 1'b0;
        end else begin
            state <= next_state;

            // CAMBIO DE JUGADOR sólo tras UNMATCH cuando termina el delay
            if (state == UNMATCH && delay_done)
                player_reg <= ~player_reg;
        end
    end

    // Salidas por estado 
    always_comb begin
        // defaults
        clr_timers      = 1'b0;
        clr_score       = 1'b0;
        init_board      = 1'b0;
        random_enable   = 1'b0;
        board_write     = 1'b0;
        start_timer     = 1'b0;
        show_7seg       = 1'b0;
        scan_buttons    = 1'b0;
        random_pick     = 1'b0;
        flip_sel_card   = 1'b0;
        store_sel_card  = 1'b0;
        compare_enable  = 1'b0;
        lock_pair       = 1'b0;
        inc_score       = 1'b0;
        short_delay     = 1'b0;
        hide_cards      = 1'b0;
        display_winner  = 1'b0;

        unique case (state)
            RESET_INIT: begin
                clr_timers = 1;
                clr_score  = 1;
                init_board = 1;
            end

            SHUFFLE: begin
                random_enable = 1;
                board_write   = 1;
            end

            TURN_START: begin
                // reinicia timer y muestra display
                clr_timers = 1;
                start_timer= 1;
                show_7seg  = 1;
            end

            WAIT_SELECTION: begin
                start_timer  = 1;
                scan_buttons = 1;
            end

            REVEAL: begin
                flip_sel_card  = 1;
                store_sel_card = 1;
            end

            AUTO_PICK: begin
                random_pick    = 1;
                flip_sel_card  = 1;
                store_sel_card = 1;
            end

            EVALUATE_PAIR: begin
                compare_enable = 1;
            end

            MATCH: begin
                lock_pair = 1;
                inc_score = 1;
            end

            UNMATCH: begin
                short_delay = 1;
            end

            HIDE_PAIR: begin
                hide_cards = 1;
            end

            GAME_OVER: begin
                display_winner = 1;
            end
        endcase
    end

    // Próximo estado
    always_comb begin
        next_state = state;
        unique case (state)
            RESET_INIT:
                next_state = SHUFFLE;

            SHUFFLE:
                if (shuffle_done) next_state = TURN_START;

            TURN_START:
                next_state = WAIT_SELECTION;

            WAIT_SELECTION: begin
                if (btn_valid)
                    next_state = REVEAL;
                else if (t15s_expired)
                    next_state = AUTO_PICK;
            end

            REVEAL: begin
                if (sel_count == 2'd1)
                    next_state = WAIT_SELECTION;
                else if (sel_count == 2'd2)
                    next_state = EVALUATE_PAIR;
            end

            AUTO_PICK: begin
                if (sel_count == 2'd1)
                    next_state = AUTO_PICK;       // falta 1
                else if (sel_count == 2'd2)
                    next_state = EVALUATE_PAIR;   // listo para comparar
            end

            EVALUATE_PAIR: begin
                if (match) next_state = MATCH;
                else       next_state = UNMATCH;
            end

            MATCH: begin
                if (all_pairs) next_state = GAME_OVER;
                else           next_state = TURN_START; // mismo jugador sigue
            end

            UNMATCH:
                if (delay_done) next_state = HIDE_PAIR;

            HIDE_PAIR:
                next_state = TURN_START; // cambia jugador en el secuencial

            GAME_OVER: begin
                if (rst) next_state = RESET_INIT;
            end
        endcase
    end

endmodule
