module Ripple_carry_adder32(
	input logic [31:0] A,
	input logic [31:0] B, 
	input logic Cin,
	output logic [31:0] Sum,
	output logic Cout,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);

	logic c[31:0];
	
	
	// Instancias de Full Adder
	Full_Adder a0 (.A(A[0]), .B(B[0]), .Cin(Cin), .Sum(Sum[0]), .Cout(c[0]));
	Full_Adder a1 (.A(A[1]), .B(B[1]), .Cin(c[0]), .Sum(Sum[1]), .Cout(c[1]));
	Full_Adder a2 (.A(A[2]), .B(B[2]), .Cin(c[1]), .Sum(Sum[2]), .Cout(c[2]));
	Full_Adder a3 (.A(A[3]), .B(B[3]), .Cin(c[2]), .Sum(Sum[3]), .Cout(c[3]));
	Full_Adder a4 (.A(A[4]), .B(B[4]), .Cin(c[3]), .Sum(Sum[4]), .Cout(c[4]));
	Full_Adder a5 (.A(A[5]), .B(B[5]), .Cin(c[4]), .Sum(Sum[5]), .Cout(c[5]));
	Full_Adder a6 (.A(A[6]), .B(B[6]), .Cin(c[5]), .Sum(Sum[6]), .Cout(c[6]));
	Full_Adder a7 (.A(A[7]), .B(B[7]), .Cin(c[6]), .Sum(Sum[7]), .Cout(c[7]));
	Full_Adder a8 (.A(A[8]), .B(B[8]), .Cin(c[7]), .Sum(Sum[8]), .Cout(c[8]));
	Full_Adder a9 (.A(A[9]), .B(B[9]), .Cin(c[8]), .Sum(Sum[9]), .Cout(c[9]));
	Full_Adder a10 (.A(A[10]), .B(B[10]), .Cin(c[9]), .Sum(Sum[10]), .Cout(c[10]));
	Full_Adder a11 (.A(A[11]), .B(B[11]), .Cin(c[10]), .Sum(Sum[11]), .Cout(c[11]));
	Full_Adder a12 (.A(A[12]), .B(B[12]), .Cin(c[11]), .Sum(Sum[12]), .Cout(c[12]));
	Full_Adder a13 (.A(A[13]), .B(B[13]), .Cin(c[12]), .Sum(Sum[13]), .Cout(c[13]));
	Full_Adder a14 (.A(A[14]), .B(B[14]), .Cin(c[13]), .Sum(Sum[14]), .Cout(c[14]));
	Full_Adder a15 (.A(A[15]), .B(B[15]), .Cin(c[14]), .Sum(Sum[15]), .Cout(c[15]));
	Full_Adder a16 (.A(A[16]), .B(B[16]), .Cin(c[15]), .Sum(Sum[16]), .Cout(c[16]));
	Full_Adder a17 (.A(A[17]), .B(B[17]), .Cin(c[16]), .Sum(Sum[17]), .Cout(c[17]));
	Full_Adder a18 (.A(A[18]), .B(B[18]), .Cin(c[17]), .Sum(Sum[18]), .Cout(c[18]));
	Full_Adder a19 (.A(A[19]), .B(B[19]), .Cin(c[18]), .Sum(Sum[19]), .Cout(c[19]));
	Full_Adder a20 (.A(A[20]), .B(B[20]), .Cin(c[19]), .Sum(Sum[20]), .Cout(c[20]));
	Full_Adder a21 (.A(A[21]), .B(B[21]), .Cin(c[20]), .Sum(Sum[21]), .Cout(c[21]));
	Full_Adder a22 (.A(A[22]), .B(B[22]), .Cin(c[21]), .Sum(Sum[22]), .Cout(c[22]));
	Full_Adder a23 (.A(A[23]), .B(B[23]), .Cin(c[22]), .Sum(Sum[23]), .Cout(c[23]));
	Full_Adder a24 (.A(A[24]), .B(B[24]), .Cin(c[23]), .Sum(Sum[24]), .Cout(c[24]));
	Full_Adder a25 (.A(A[25]), .B(B[25]), .Cin(c[24]), .Sum(Sum[25]), .Cout(c[25]));
	Full_Adder a26 (.A(A[26]), .B(B[26]), .Cin(c[25]), .Sum(Sum[26]), .Cout(c[26]));
	Full_Adder a27 (.A(A[27]), .B(B[27]), .Cin(c[26]), .Sum(Sum[27]), .Cout(c[27]));
	Full_Adder a28 (.A(A[28]), .B(B[28]), .Cin(c[27]), .Sum(Sum[28]), .Cout(c[28]));
	Full_Adder a29 (.A(A[29]), .B(B[29]), .Cin(c[28]), .Sum(Sum[29]), .Cout(c[29]));
	Full_Adder a30 (.A(A[30]), .B(B[30]), .Cin(c[29]), .Sum(Sum[30]), .Cout(c[30]));
	Full_Adder a31 (.A(A[31]), .B(B[31]), .Cin(c[30]), .Sum(Sum[31]), .Cout(Cout));

	// Flags
   assign N = Sum[31];          // MSB 
   assign Z = (Sum == 32'd0);   // Cuando todo es cero
   assign C = Cout;            // El carry de salida
   assign V = (~(A[31] ^ B[31])) & (A[31] ^ Sum[31]); // Si se suman 2 y cambia el signo
  
  
endmodule