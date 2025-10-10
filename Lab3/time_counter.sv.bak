module time_counter(
    input logic clk,
    input logic reset,
    input logic tick,  // Señal de segundo
    output logic [5:0] seconds
);
always @(posedge clk or posedge reset) begin
    if (reset) begin
        seconds <= 0;
    end else if (tick) begin
        if (seconds == 15) begin
            seconds <= 0;
        end else begin
            seconds <= seconds + 1;
        end
    end
end
endmodule