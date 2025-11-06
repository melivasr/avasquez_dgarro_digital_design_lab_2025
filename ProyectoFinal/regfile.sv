module regfile(
    input logic clk, we3,
    input logic reset, 
    input logic [3:0] ra1, ra2, wa3,
    input logic [31:0] wd3, r15,
    output logic [31:0] rd1, rd2
);
    logic [31:0] rf[14:0];
    
    always_ff @(posedge clk, posedge reset)
        if (reset) begin
            // Inicializar todos los registros a 0
            rf[0] <= 32'b0;
            rf[1] <= 32'b0;
            rf[2] <= 32'b0;
            rf[3] <= 32'b0;
            rf[4] <= 32'b0;
            rf[5] <= 32'b0;
            rf[6] <= 32'b0;
            rf[7] <= 32'b0;
            rf[8] <= 32'b0;
            rf[9] <= 32'b0;
            rf[10] <= 32'b0;
            rf[11] <= 32'b0;
            rf[12] <= 32'b0;
            rf[13] <= 32'b0;
            rf[14] <= 32'b0;
        end else if (we3)
            rf[wa3] <= wd3;
    
    assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
    assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
    
endmodule