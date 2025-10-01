module time_counter(
    input  logic clk,
    input  logic reset,
    input  logic tick,
    output logic [5:0] seconds
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            seconds <= 6'd15; // iniciar en 15
        end else if (tick) begin
            if (seconds == 6'd0) seconds <= 6'd15;
            else
					seconds <= seconds - 6'd1;
        end
    end
endmodule
