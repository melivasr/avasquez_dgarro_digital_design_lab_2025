module ALU2 (
    input  logic clk,
    input  logic reset,
    input  logic [31:0] A, B,
    input  logic [3:0] op,
    output logic [31:0] Y
);
    logic [31:0] regA, regB;
    logic [31:0] aluO;
    
    // Registro de entrada
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            regA <= '0;
            regB <= '0;
        end else begin
            regA <= A;
            regB <= B;
        end
    end
    
    // ALU
    Alu_control2 alu (.A(regA), .B(regB), .op(op), .Y(aluO));

    // Registro de salida
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            Y <= '0;
        else
            Y <= aluO;
    end
	 
endmodule