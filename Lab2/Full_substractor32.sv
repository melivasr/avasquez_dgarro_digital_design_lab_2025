module Full_subtractor32(
	input logic [31:0] A,
	input logic [31:0] B, 
	input logic Cin,
	output logic [31:0] Sub,
	output logic Cout,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);
	logic c[31:0];
	
	// Instancias de Full substractor
	Full_Substractor a0 (.A(A[0]), .B(B[0]), .Cin(Cin), .Sub(Sub[0]), .Cout(c[0]));
	Full_Substractor a1 (.A(A[1]), .B(B[1]), .Cin(c[0]), .Sub(Sub[1]), .Cout(c[1]));
	Full_Substractor a2 (.A(A[2]), .B(B[2]), .Cin(c[1]), .Sub(Sub[2]), .Cout(c[2]));
	Full_Substractor a3 (.A(A[3]), .B(B[3]), .Cin(c[2]), .Sub(Sub[3]), .Cout(c[3]));
	Full_Substractor a4 (.A(A[4]), .B(B[4]), .Cin(c[3]), .Sub(Sub[4]), .Cout(c[4]));
	Full_Substractor a5 (.A(A[5]), .B(B[5]), .Cin(c[4]), .Sub(Sub[5]), .Cout(c[5]));
	Full_Substractor a6 (.A(A[6]), .B(B[6]), .Cin(c[5]), .Sub(Sub[6]), .Cout(c[6]));
	Full_Substractor a7 (.A(A[7]), .B(B[7]), .Cin(c[6]), .Sub(Sub[7]), .Cout(c[7]));
	Full_Substractor a8 (.A(A[8]), .B(B[8]), .Cin(c[7]), .Sub(Sub[8]), .Cout(c[8]));
	Full_Substractor a9 (.A(A[9]), .B(B[9]), .Cin(c[8]), .Sub(Sub[9]), .Cout(c[9]));
	Full_Substractor a10 (.A(A[10]), .B(B[10]), .Cin(c[9]), .Sub(Sub[10]), .Cout(c[10]));
	Full_Substractor a11 (.A(A[11]), .B(B[11]), .Cin(c[10]), .Sub(Sub[11]), .Cout(c[11]));
	Full_Substractor a12 (.A(A[12]), .B(B[12]), .Cin(c[11]), .Sub(Sub[12]), .Cout(c[12]));
	Full_Substractor a13 (.A(A[13]), .B(B[13]), .Cin(c[12]), .Sub(Sub[13]), .Cout(c[13]));
	Full_Substractor a14 (.A(A[14]), .B(B[14]), .Cin(c[13]), .Sub(Sub[14]), .Cout(c[14]));
	Full_Substractor a15 (.A(A[15]), .B(B[15]), .Cin(c[14]), .Sub(Sub[15]), .Cout(c[15]));
	Full_Substractor a16 (.A(A[16]), .B(B[16]), .Cin(c[15]), .Sub(Sub[16]), .Cout(c[16]));
	Full_Substractor a17 (.A(A[17]), .B(B[17]), .Cin(c[16]), .Sub(Sub[17]), .Cout(c[17]));
	Full_Substractor a18 (.A(A[18]), .B(B[18]), .Cin(c[17]), .Sub(Sub[18]), .Cout(c[18]));
	Full_Substractor a19 (.A(A[19]), .B(B[19]), .Cin(c[18]), .Sub(Sub[19]), .Cout(c[19]));
	Full_Substractor a20 (.A(A[20]), .B(B[20]), .Cin(c[19]), .Sub(Sub[20]), .Cout(c[20]));
	Full_Substractor a21 (.A(A[21]), .B(B[21]), .Cin(c[20]), .Sub(Sub[21]), .Cout(c[21]));
	Full_Substractor a22 (.A(A[22]), .B(B[22]), .Cin(c[21]), .Sub(Sub[22]), .Cout(c[22]));
	Full_Substractor a23 (.A(A[23]), .B(B[23]), .Cin(c[22]), .Sub(Sub[23]), .Cout(c[23]));
	Full_Substractor a24 (.A(A[24]), .B(B[24]), .Cin(c[23]), .Sub(Sub[24]), .Cout(c[24]));
	Full_Substractor a25 (.A(A[25]), .B(B[25]), .Cin(c[24]), .Sub(Sub[25]), .Cout(c[25]));
	Full_Substractor a26 (.A(A[26]), .B(B[26]), .Cin(c[25]), .Sub(Sub[26]), .Cout(c[26]));
	Full_Substractor a27 (.A(A[27]), .B(B[27]), .Cin(c[26]), .Sub(Sub[27]), .Cout(c[27]));
	Full_Substractor a28 (.A(A[28]), .B(B[28]), .Cin(c[27]), .Sub(Sub[28]), .Cout(c[28]));
	Full_Substractor a29 (.A(A[29]), .B(B[29]), .Cin(c[28]), .Sub(Sub[29]), .Cout(c[29]));
	Full_Substractor a30 (.A(A[30]), .B(B[30]), .Cin(c[29]), .Sub(Sub[30]), .Cout(c[30]));
	Full_Substractor a31 (.A(A[31]), .B(B[31]), .Cin(c[30]), .Sub(Sub[31]), .Cout(Cout));

   // Flags
   assign N = Sub[31];          // MSB 
   assign Z = (Sub == 32'd0);   // Cuando todo es cero
   assign C = Cout;            // El carry de salida
   assign V = (~(A[31] ^ B[31])) & (A[31] ^ Sub[31]); // Si se suman 2 y cambia el signo
	
endmodule