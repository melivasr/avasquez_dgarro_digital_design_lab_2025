module Multiplicacion(
    input logic [3:0] A,
    input logic [3:0] B,
    output logic [3:0] P,
    output logic N,
    output logic Z,
    output logic C,
    output logic V
);
	
	
	logic p0, p1, p2, p3, p4, p5, p6, p7, p8, p9;
	
	
	//Primera columna
	AND_gate and0(.a(A[0]), .b(B[0]), .y(p0));
	
	//Segunda columna
	AND_gate and1(.a(A[1]), .b(B[0]), .y(p1));
	AND_gate and2(.a(A[0]), .b(B[1]), .y(p2));
	
	//Tercera columna
	AND_gate and3(.a(A[2]), .b(B[0]), .y(p3));
	AND_gate and4(.a(A[1]), .b(B[1]), .y(p4));
	AND_gate and5(.a(A[0]), .b(B[2]), .y(p5));
	
	//Cuarta columna
	AND_gate and6(.a(A[3]), .b(B[0]), .y(p6));
	AND_gate and7(.a(A[2]), .b(B[1]), .y(p7));
	AND_gate and8(.a(A[1]), .b(B[2]), .y(p8));
	AND_gate and9(.a(A[0]), .b(B[3]), .y(p9));
	
	//Primer bit de P
	assign P[0] = p0;
	
	//Segundo bit de P
	logic c1;
	Full_Adder fa1 (.A(p1), .B(p2), .Cin(1'b0), .Sum(P[1]), .Cout(c1));
	
	//Tercer bit de P
	logic c2, c3, s1;
	Full_Adder fa2 (.A(p3), .B(p4), .Cin(c1), .Sum(s1), .Cout(c2));
	Full_Adder fa3 (.A(s1), .B(p5), .Cin(1'b0), .Sum(P[2]), .Cout(c3));
	
	//Cuarto bit de P
	logic c4, c5, c6, s2, s3;
	Full_Adder fa4 (.A(p6), .B(p7), .Cin(c2), .Sum(s2), .Cout(c4));
	Full_Adder fa5 (.A(s2), .B(p8), .Cin(c3), .Sum(s3), .Cout(c5));
	Full_Adder fa6 (.A(s3), .B(p9), .Cin(1'b0), .Sum(P[3]), .Cout(c6));
	
	// Flags
   assign N = P[3];          // MSB
   assign Z = (P == 4'd0);   // Cuando todo es cero
   assign C = c6;            // El carry de salida
   assign V = (A[3] ^ B[3]) & (A[3] ^ P[3]); // Si se suman 2 y cambia el signo 

endmodule