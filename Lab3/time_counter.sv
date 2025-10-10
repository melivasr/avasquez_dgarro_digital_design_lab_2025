module time_counter(
    input  logic clk,
    input  logic reset,
    input  logic tick,   // pulso de 1 Hz
    input  logic start,  // arranca desde la FSM
    output logic expired,
    output logic [5:0] seconds
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            seconds <= 6'd15;   // inicia en 15
            expired <= 0;
        end else if (start && tick) begin
            if (seconds == 0) begin
                seconds <= 6'd15;   
                expired <= 1;       // pulso
            end else begin
                seconds <= seconds - 1;
                expired <= 0;
            end
        end else begin
            expired <= 0;
        end
    end
endmodule
