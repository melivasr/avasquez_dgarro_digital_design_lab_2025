module auto_picker(
    input  logic        clk,
    input  logic        rst,
    input  logic        start,           // 1 sólo en estado AUTO_PICK
    input  logic [15:0] reveal_mask,
    input  logic [15:0] locked_mask,
    input  logic [1:0]  sel_count,       // 0..2

    output logic [5:0]  pick_idx,        // 0..15
    output logic        pick_pulse       // pulso 1 clk
);
    // Temporales 
    wire [15:0] temp_mask = reveal_mask & ~locked_mask;

    // RNG
    logic [7:0] rnd;
    random u_rng(.clk(clk), .rst(rst), .seed(8'h3C), .rnd(rnd));

    // FSM interna
    typedef enum logic [1:0] {IDLE, SEARCH, FIRE} pstate_t;
    pstate_t ps, ns;

    logic [4:0] probe;          // 0..15
    logic [1:0] emitted;        // picks emitidos en este AUTO_PICK (0..2)

    // 
    logic start_d;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) start_d <= 1'b0;
        else     start_d <= start;
    end
    wire start_rise = start & ~start_d;
    wire start_fall = ~start &  start_d;

    // Carta válida: no bloqueada ni ya tomada temporalmente
    wire valid_here = (probe < 5'd16) &&
                      !locked_mask[probe[3:0]] &&
                      !temp_mask[probe[3:0]];

    // Secuencial
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ps         <= IDLE;
            probe      <= 5'd0;
            emitted    <= 2'd0;
            pick_idx   <= 6'd0;
            pick_pulse <= 1'b0;
        end else begin
            
            pick_pulse <= 1'b0;

            // Resetear contadores al comenzar o terminar AUTO_PICK
            if (start_rise) begin
                emitted <= 2'd0;
                probe   <= (rnd[4:0] & 5'd15); // semilla
            end
            if (start_fall) begin
                ps      <= IDLE;
                emitted <= 2'd0;
            end else begin
                ps <= ns;
            end

            // Avance de probe
            if (ps == SEARCH && start) begin
                if (!valid_here) begin
                    probe <= (probe == 5'd15) ? 5'd0 : (probe + 5'd1);
                end
            end

            // Disparo
            if (ps == FIRE && start) begin
                pick_idx   <= {1'b0, probe[3:0]}; // 0..15
                pick_pulse <= 1'b1;               // 1 ciclo
                emitted    <= emitted + 2'd1;
                probe      <= (probe + 5'd3) & 5'd15;
            end

            // Si ya hay 2 seleccionadas, volvemos a IDLE por hardware
            if (sel_count == 2) begin
                ps      <= IDLE;
                emitted <= 2'd0;
            end
        end
    end

    // Combinacional de estados
    always_comb begin
        ns = ps;

        unique case (ps)
            IDLE: begin
                // Sólo si start=1, y faltan picks (2 - sel_count)
                if (start && (sel_count < 2) && (emitted < (2 - sel_count)))
                    ns = SEARCH;
            end

            SEARCH: begin
                if (!start)                   ns = IDLE;         // guard clause
                else if (sel_count == 2)      ns = IDLE;         // ya no falta nada
                else if (valid_here)          ns = FIRE;
                else                          ns = SEARCH;
            end

            FIRE: begin
                // Volver a IDLE y evaluar si falta otro pick en la próxima vuelta
                ns = IDLE;
            end
        endcase
    end
endmodule
