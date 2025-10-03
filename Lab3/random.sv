module random(
    input  logic clk, rst,
    input  logic [3:0] init,
    output logic [3:0] rnd
);
    logic feedback;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) rnd <= init;
        else begin
            feedback = ~(rnd[3] ^ rnd[2]);
            rnd <= {rnd[2:0], feedback};
        end
    end
endmodule