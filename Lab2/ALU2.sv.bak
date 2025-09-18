module ALU2 
	#(parameter width = 4)(
    input  logic clk,
    input  logic reset,
    input  logic [width-1:0] A, B,
    input  logic [3:0] op,
    output logic [width-1:0] Y
);
    logic [width-1:0] regA, regB;
    logic [width-1:0] aluO;
    
    // Registro de entrada
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            regA <= A;
            regB <= B;
        end
    end
    
    // ALU
    Alu_control2 #(.width(width)) alu_inst (.A(regA), .B(regB), .op(op), .Y(aluO));

    // Registro de salida
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            Y <= aluO;
    end
	 
endmodule