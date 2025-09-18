module Full_subtractor4(
	input logic [3:0] A,
	input logic [3:0] B, 
	input logic Cin,
	output logic [3:0] Sub,
	output logic Cout,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);
	logic c1, c2, c3;
	
	// Instancias de Full Adder 1-bit
	Full_Substractor s0 (.A(A[0]), .B(B[0]), .Cin(Cin), .Sub(Sub[0]), .Cout(c1));
	Full_Substractor s1 (.A(A[1]), .B(B[1]), .Cin(c1),  .Sub(Sub[1]), .Cout(c2));
	Full_Substractor s2 (.A(A[2]), .B(B[2]), .Cin(c2),  .Sub(Sub[2]), .Cout(c3));
	Full_Substractor s3 (.A(A[3]), .B(B[3]), .Cin(c3),  .Sub(Sub[3]), .Cout(Cout));

	// Flags
   assign N = Sub[3];          // MSB
   assign Z = (Sub == 4'd0);   // Cuando todo es cero
   assign C = Cout;            // El carry de salida
   assign V = (A[3] ^ B[3]) & (A[3] ^ Sub[3]); // Si se suman 2 y cambia el signo 
	
endmodule