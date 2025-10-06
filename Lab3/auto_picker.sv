module auto_picker(
    input  logic        clk,
    input  logic        rst,
    input  logic        start,           // random_pick de la FSM (alto en AUTO_PICK)
    input  logic [15:0] reveal_mask,     // visibles (temp o bloqueadas)
    input  logic [15:0] locked_mask,     // bloqueadas (pares ya fijos)
    input  logic [1:0]  sel_count,       // # cartas ya elegidas (0..2)

    output logic [5:0]  pick_idx,        // índice elegido 0..15
    output logic        pick_pulse       // pulso 1 clk para “seleccionar”
);
    // Temporales = reveladas pero no bloqueadas
    wire [15:0] temp_mask = reveal_mask & ~locked_mask;

    // RNG simple
    logic [7:0] rnd;
    random u_rng(.clk(clk), .rst(rst), .seed(8'h3C), .rnd(rnd));

    // FSM interna
    typedef enum logic [1:0] {IDLE, SEARCH, FIRE} pstate_t;
    pstate_t ps, ns;

    logic [4:0] probe;     // 
    logic [1:0] emitted;   // AUTO_PICK (0..2)

    // Carta válida si no está bloqueada ni ya escogida temporalmente
    wire valid_here = (probe < 5'd16) &&
                      !locked_mask[probe[3:0]] &&
                      !temp_mask[probe[3:0]];

   
    logic start_d;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) start_d <= 1'b0;
        else     start_d <= start;
    end
    wire start_rise = start & ~start_d;

    //Secuencial
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ps         <= IDLE;
            probe      <= 5'd0;
            emitted    <= 2'd0;
            pick_idx   <= 6'd0;
            pick_pulse <= 1'b0;
        end else begin
            ps         <= ns;
            pick_pulse <= 1'b0;  // por defecto

            
            if (start_rise) begin
                emitted <= 2'd0;
                probe   <= rnd[4:0] & 5'd15; // 0..15
            end

            //  si no es válido, avanza 
            if (ps == SEARCH) begin
                if (!valid_here) begin
                    probe <= (probe == 5'd15) ? 5'd0 : (probe + 5'd1);
                end
            end

           
            if (ps == FIRE) begin
                pick_idx   <= {1'b0, probe[3:0]}; 
                pick_pulse <= 1'b1;               // 1 ciclo
                emitted    <= emitted + 2'd1;
                probe      <= (probe + 5'd3) & 5'd15;
            end
        end
    end

    always_comb begin
        ns = ps;
        unique case (ps)
            IDLE: begin
                // necesitamos completar hasta 2 picks (2 - sel_count)
                if (start && (emitted < (2 - sel_count)))
                    ns = SEARCH;
            end
            SEARCH: begin
                if (valid_here) ns = FIRE;
                else            ns = SEARCH; 
            end
            FIRE: begin
           
                ns = IDLE;
            end
        endcase
    end
endmodule
