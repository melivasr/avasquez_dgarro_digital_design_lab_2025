module controladora_FSM (
	input logic clk,
	input logic rst,
	input logic shuffle_done,   // Indica si las cartas tan barajadas
	input logic btn_valid,      // Señala que la jugada ingresada es válida
	input logic t15s_expired,   // Tiempo se agotó 15s
	input logic match,          // comparación de cartas
	input logic all_pairs,      // todas las parejas encontradas
	input logic delay_done,		 // Fin del tiempo de espera
	
	
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
	output logic player,      // Selección del jugador 
	output logic [1:0]  sel_count // Las cartas seleccionadas
);
	
	typedef enum logic [3:0] {
		RESET_INIT = 4'b0000,
		SHUFFLE = 4'b0001,
		TURN_START = 4'b0010,
		WAIT_SELECTION = 4'b0011,
		REVEAL = 4'b0100,
		AUTO_PICK = 4'b0101,
		EVALUATE_PAIR = 4'b0110,
		MATCH = 4'b0111,
		UNMATCH = 4'b1000,
		HIDE_PAIR = 4'b1001,
		GAME_OVER = 4'b1010
	} state_type;
	 
	state_type state, next_state;
	
	logic [1:0] sel_count_reg;
	logic player_reg;
	
	assign sel_count = sel_count_reg;
	assign player = player_reg;	
	
	
	//  Actualiza el estado cada rst o clk
	always_ff @(posedge clk or posedge rst) begin
		if(rst) begin
			state = RESET_INIT;
			sel_count_reg = 2'b00;
			player_reg = 0;
		end
		
		else begin 
			state = next_state;
			
			case (state)
				TURN_START: sel_count_reg = 0;
				REVEAL: sel_count_reg = sel_count_reg + 1;
				AUTO_PICK: sel_count_reg = sel_count_reg + 1;
				default: sel_count_reg = sel_count_reg;
			endcase
			
			// cambio de jugador
        if (state == HIDE_PAIR)
            player_reg = ~player_reg;
		end
	end
			
	// Cambio de outputs 
	always_comb begin 
	
		// Valores default pa cuando inicie el ciclo
		clr_timers = 0;
		clr_score  = 0;
		init_board = 0;
		random_enable = 0;
		board_write = 0;
		start_timer = 0;
		show_7seg   = 0;
		scan_buttons= 0;
		random_pick = 0;
		flip_sel_card = 0;
		store_sel_card= 0;
		compare_enable= 0;
		lock_pair   = 0;
		inc_score   = 0;
		short_delay = 0;
		hide_cards  = 0;
		display_winner = 0;
		
		
		case (state)
			RESET_INIT: begin
				clr_timers = 1;
				clr_score = 1;
				init_board = 1;
			end
			
			SHUFFLE: begin 
				random_enable = 1;
				board_write = 1;
			end
			
			TURN_START: begin
				start_timer = 1;
				show_7seg = 1;
			end
			
			WAIT_SELECTION: begin
				start_timer = 1;
				scan_buttons = 1;
			end
			
			REVEAL: begin 
				flip_sel_card = 1;
				store_sel_card = 1;
			end
			
			AUTO_PICK: begin
				random_pick = 1;
				flip_sel_card = 1;
				store_sel_card = 1;
			end
			
			EVALUATE_PAIR:
				compare_enable = 1;
			
			MATCH: begin
				lock_pair = 1;
				inc_score = 1;
			end
			
			UNMATCH:
				short_delay = 1;
			
			HIDE_PAIR: begin
				hide_cards = 1;
			end
			
			GAME_OVER:
				display_winner = 1;
				
		endcase
	end
	
	
	
	// Logica del cambio de estado
	always_comb begin
		next_state = state;
		case (state)
			RESET_INIT: 
				next_state = SHUFFLE;
			
			SHUFFLE: 
				if(shuffle_done)
					next_state = TURN_START;
			
			TURN_START: 
				next_state = WAIT_SELECTION;
			
			WAIT_SELECTION: begin
				if(btn_valid) 
					next_state = REVEAL;
				else if (t15s_expired)
					next_state = AUTO_PICK;
			end
			
			REVEAL: begin 
				if(sel_count == 1)
					next_state = WAIT_SELECTION;
				else if(sel_count == 2)
					next_state = EVALUATE_PAIR;
			end
			
			AUTO_PICK: begin
				if(sel_count == 1) 
					next_state = AUTO_PICK;
				else if(sel_count == 2)
					next_state = EVALUATE_PAIR;
			end
			
			EVALUATE_PAIR: begin
				if(match)
					next_state = MATCH;
				else
					next_state = UNMATCH;
			end
			
			MATCH: begin
				if(all_pairs)
					next_state = GAME_OVER;
				else
					next_state = TURN_START;
			end
			
			UNMATCH: 
				if(delay_done)
					next_state = HIDE_PAIR;
			
			HIDE_PAIR:
				next_state = TURN_START;
				
			GAME_OVER: begin
				if(rst)
					next_state = RESET_INIT;
			end
		endcase
	end
				
endmodule