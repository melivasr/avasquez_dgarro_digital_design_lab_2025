module auto_picker #(
    parameter int STEP_CYCLES = 2_000_000, // ~40 ms a 50 MHz
    parameter int WAIT_CYCLES = 3_000_000  // ~60 ms a 50 MHz
)(
    input  logic        clk,
    input  logic        rst,
    input  logic        start,           // 1 en estado AUTO_PICK 
    input  logic [15:0] reveal_mask,
    input  logic [15:0] locked_mask,
    input  logic [1:0]  sel_count,       // 0..2

    output logic [5:0]  pick_idx,        // 0..15
    output logic        pick_pulse       // 1 clk
);
    // cartas temporales (reveladas pero no bloqueadas)
    wire [15:0] temp_mask = reveal_mask & ~locked_mask;

    logic [7:0] rnd;
    random u_rng(.clk(clk), .rst(rst), .seed(8'h3C), .rnd(rnd));

    // FSM interna
    typedef enum logic [1:0] {IDLE, SCAN, PICK, WAIT} pstate_t;
    pstate_t ps, ns;

    logic [4:0] probe;      // 0..15
    logic [1:0] emitted;    

    // flancos de start
    logic start_d;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) start_d <= 1'b0;
        else     start_d <= start;
    end
    wire start_rise =  start & ~start_d;
    wire start_fall = ~start &  start_d;

    // válido si no está bloqueada ni temporal
    wire valid_here = (probe < 5'd16) &&
                      !locked_mask[probe[3:0]] &&
                      !temp_mask[probe[3:0]];

    // ticks de SCAN y de espera
    localparam int CW_STEP = (STEP_CYCLES>0) ? $clog2(STEP_CYCLES) : 1;
    localparam int CW_WAIT = (WAIT_CYCLES>0) ? $clog2(WAIT_CYCLES) : 1;

    logic [CW_STEP-1:0] step_cnt;
    logic               step_tick;

    logic [CW_WAIT-1:0] wait_cnt;
    logic               wait_done;

    // tick de SCAN
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            step_cnt  <= '0;
            step_tick <= 1'b0;
        end else begin
            step_tick <= 1'b0;
            if (ps==SCAN && start && (sel_count<2)) begin
                if (step_cnt == CW_STEP'(STEP_CYCLES-1)) begin
                    step_cnt  <= '0;
                    step_tick <= 1'b1;
                end else begin
                    step_cnt <= step_cnt + CW_STEP'(1);
                end
            end else begin
                step_cnt <= '0;
            end
        end
    end

    // espera tras PICK
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wait_cnt  <= '0;
            wait_done <= 1'b0;
        end else begin
            wait_done <= 1'b0;
            if (ps==WAIT && start) begin
                if (wait_cnt == WAIT_CYCLES-1) begin
                    wait_cnt  <= '0;
                    wait_done <= 1'b1;
                end else begin
                    wait_cnt <= wait_cnt + 1'b1;
                end
            end else begin
                wait_cnt <= '0;
            end
        end
    end

    // secuencial
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ps         <= IDLE;
            probe      <= 5'd0;
            emitted    <= 2'd0;
            pick_idx   <= 6'd0;
            pick_pulse <= 1'b0;
        end else begin
            pick_pulse <= 1'b0;

            // al entrar a AUTO_PICK, reinicia contadores
            if (start_rise) begin
                emitted <= 2'd0;
                probe   <= (rnd[4:0] & 5'd15);
            end

            // si salimos de AUTO_PICK o ya hay 2 cartas levantadas 
            if (start_fall || (sel_count==2)) begin
                ps      <= IDLE;
                emitted <= 2'd0;
            end else begin
                ps <= ns;
            end

            // avance 
            if (ps==SCAN && start && step_tick) begin
                if (!valid_here)
                    probe <= (probe == 5'd15) ? 5'd0 : (probe + 5'd1);
            end

            // emite pick
            if (ps==PICK && start) begin
                pick_idx   <= {1'b0, probe[3:0]};
                pick_pulse <= 1'b1;
                emitted    <= emitted + 2'd1;
                probe      <= (probe + 5'd3) & 5'd15;
            end
        end
    end

    // próximo estado 
    always_comb begin
        ns = ps;
        unique case (ps)
            IDLE: begin
                if (start && (sel_count<2) && (emitted < 2))
                    ns = SCAN;
            end
            SCAN: begin
                if (!start || sel_count==2)          ns = IDLE;
                else if (step_tick && valid_here)     ns = PICK;
                else                                   ns = SCAN;
            end
            PICK: begin
                ns = WAIT; // pausa corta
            end
            WAIT: begin
                if (!start || sel_count==2)           ns = IDLE;
                else if (wait_done) begin
                    if (emitted < 2)                  ns = SCAN;
                    else                               ns = IDLE;
                end else                               ns = WAIT;
            end
        endcase
    end
endmodule
