module Ripple_carry_adder4
	#(parameter width = 4)(
	input logic [width-1:0] A,
	input logic [width-1:0] B, 
	input logic Cin,
	output logic [width-1:0] Sum,
	output logic Cout,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);
	logic c1, c2, c3;
	
	// Instancias de Full Adder 1-bit
	Full_Adder a0 (.A(A[0]), .B(B[0]), .Cin(Cin), .Sum(Sum[0]), .Cout(c1));
	Full_Adder a1 (.A(A[1]), .B(B[1]), .Cin(c1),  .Sum(Sum[1]), .Cout(c2));
	Full_Adder a2 (.A(A[2]), .B(B[2]), .Cin(c2),  .Sum(Sum[2]), .Cout(c3));
	Full_Adder a3 (.A(A[3]), .B(B[3]), .Cin(c3),  .Sum(Sum[3]), .Cout(Cout));
	
	
	// Flags
   assign N = Sum[3];          // MSB 
   assign Z = (Sum == 4'd0);   // Cuando todo es cero
   assign C = Cout;            // El carry de salida
   assign V = (~(A[3] ^ B[3])) & (A[3] ^ Sum[3]); // Si se suman 2 y cambia el signo
  
  
endmodule