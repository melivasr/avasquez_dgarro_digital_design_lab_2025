module selection_manager(
    input  logic       clk,
    input  logic       rst,

    // índice de la carta bajo el cursor
    input  logic [5:0] sel_idx,

    // pulso (1 clk) del switch 
    input  logic       sel_pulse,

    // habilita selección del usuario (scan_buttons en WAIT_SELECTION)
    input  logic       select_enable,

    // control de la FSM 
    input  logic       flip_sel_card,     
    input  logic       store_sel_card,    
    input  logic       hide_cards,        // HIDE_PAIR
    input  logic       lock_pair,         // MATCH
    input  logic       clr_all,           // RESET_INIT/SHUFFLE

    // estado del tablero
    input  logic [3:0] board [0:15],

    // salidas
    output logic [15:0] reveal_mask,    
    output logic [15:0] locked_mask,    // cartas ya fijas
    output logic  [1:0] sel_count,      // # selecciones temporales (0..2)
    output logic        btn_valid,      // pulso válido para la FSM (WAIT_SELECTION)
    output logic  [5:0] first_idx,
    output logic  [5:0] second_idx,
    output logic  [3:0] first_val,
    output logic  [3:0] second_val,
    output logic  [3:0] pairs_done
);
    // temporales de la jugada actual
    logic [15:0] temp_mask;
    logic [5:0]  sel_a, sel_b;
    logic [3:0]  val_a, val_b;
    logic [1:0]  count;

    assign first_idx  = sel_a;
    assign second_idx = sel_b;
    assign first_val  = val_a;
    assign second_val = val_b;
    assign sel_count  = count;

    // conteo de bloqueadas pares
    function automatic [3:0] popcount16(input logic [15:0] v);
        popcount16 = v[0]+v[1]+v[2]+v[3]+v[4]+v[5]+v[6]+v[7]+
                     v[8]+v[9]+v[10]+v[11]+v[12]+v[13]+v[14]+v[15];
    endfunction
    assign pairs_done = popcount16(locked_mask) >> 1;

    // Solo permitir selección cuando:
    //FSM habilita (select_enable = scan_buttons),
    //índice válido,
    //carta no elegida,
    wire can_pick = select_enable &&
                    (sel_idx < 6'd16) &&
                    !locked_mask[sel_idx] &&
                    !temp_mask[sel_idx] &&
                    (count < 2);

    // Latch de solicitud
    logic sel_req;

    // Pulso válido proviene del flanco + del switch 
    wire valid_pulse = sel_req && can_pick;

    // máscara visible = bloqueadas OR temporales
    assign reveal_mask = locked_mask | temp_mask;

    // Pulso para la FSM en WAIT_SELECTION 
    assign btn_valid = valid_pulse;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_mask   <= 16'h0000;
            locked_mask <= 16'h0000;
            sel_a <= 6'd0; sel_b <= 6'd0;
            val_a <= 4'd0; val_b <= 4'd0;
            count <= 2'd0;
            sel_req <= 1'b0;
        end else begin
            if (clr_all) begin
                temp_mask   <= 16'h0000;
                locked_mask <= 16'h0000;
                sel_a <= 6'd0; sel_b <= 6'd0;
                val_a <= 4'd0; val_b <= 4'd0;
                count <= 2'd0;
                sel_req <= 1'b0; // también limpiar la solicitud
            end else begin
                // Selección del usuario.
                if (valid_pulse) begin
                    // consumir solicitud latcheada
                    sel_req <= 1'b0;

                    if (!(count == 2'd1 && sel_idx == sel_a)) begin
                        temp_mask[sel_idx] <= 1'b1;

                        if (count == 2'd0) begin
                            sel_a <= sel_idx;
                            val_a <= board[sel_idx];
                            count <= 2'd1;
                        end else if (count == 2'd1) begin
                            sel_b <= sel_idx;
                            val_b <= board[sel_idx];
                            count <= 2'd2;
                        end
                    end
                end

                // Falló el par ocultar
                if (hide_cards) begin
                    temp_mask <= 16'h0000;
                    sel_a <= 6'd0; sel_b <= 6'd0;
                    val_a <= 4'd0; val_b <= 4'd0;
                    count <= 2'd0;
                    sel_req <= 1'b0; 
                end

                // Acertó el par bloquear y limpiar temporales
                if (lock_pair) begin
                    locked_mask <= locked_mask | temp_mask;
                    temp_mask   <= 16'h0000;
                    sel_a <= 6'd0; sel_b <= 6'd0;
                    val_a <= 4'd0; val_b <= 4'd0;
                    count <= 2'd0;
                    sel_req <= 1'b0; 
                end

                // capturo cualquier pulso del switch
                if (sel_pulse) sel_req <= 1'b1;
            end
        end
    end
endmodule
