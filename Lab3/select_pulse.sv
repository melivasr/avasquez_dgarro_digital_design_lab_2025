module select_pulse(
    input  logic clk,
    input  logic rst,
    input  logic sw_flip,     
    output logic sel_pulse   
);
    logic s0, s1, s1_d;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            s0 <= 1'b0; s1 <= 1'b0; s1_d <= 1'b0;
        end else begin
            s0   <= sw_flip;
            s1   <= s0;
            s1_d <= s1;
        end
    end
    assign sel_pulse = (s1 == 1'b1) && (s1_d == 1'b0);
endmodule