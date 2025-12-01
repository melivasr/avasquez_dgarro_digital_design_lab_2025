module time_counter(
    input  logic       clk,
    input  logic       reset,
    input  logic       tick,        // pulso de 1 Hz
    input  logic       start,       // orden de carga desde la FSM
    input  logic [2:0] timer,   // valor inicial 0..7
    output logic       timer_flag,     // pulso 1 ciclo al llegar a 0
    output logic [2:0] seconds      // conteo actual
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            seconds <= 3'd0;
            timer_flag <= 1'b0;
        end else begin
            timer_flag <= 1'b0;  // por defecto

            if (start) begin
                // Carga del valor inicial (prioridad sobre tick)
                seconds <= timer;
            end else if (tick) begin
                if (seconds != 3'd0) begin
                    // Dispara timer_flag solo cuando pasamos de 1 -> 0
                    timer_flag <= (seconds == 3'd1);
                    seconds <= seconds - 3'd1;
                end
                // Si ya está en 0, no re-disparar timer_flag
            end
        end
    end
endmodule

