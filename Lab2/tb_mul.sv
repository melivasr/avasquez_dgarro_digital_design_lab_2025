`timescale 1ns/1ps

module tb;

  logic [3:0] A;
  logic [3:0] B;
  logic [3:0] op;
  logic [3:0] Y;
  logic N, Z, C, V;

  Alu_control alu1 (.A(A), .B(B), .op(op), .Y(Y), .N(N), .Z(Z), .C(C), .V(V));

  initial begin

    // Probamos algunos valores
    A = 4'b0101;
	 B = 4'b0011;

    // Suma
    op = 4'b0000;
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b" , A, B, op, Y, N, Z, C, V);

    // Resta
    op = 4'b0001; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);
	 
	 // Multiplicación
    op = 4'b0010; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // División
    op = 4'b0011; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // AND
    op = 4'b0101; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // OR
    op = 4'b0110; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // XOR
    op = 4'b0111; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // Shift left
    op = 4'b1000; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // Shift right
    op = 4'b1001; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);
	 
	 
	 
	 
	 // Probamos otros algunos valores
    A = 4'b0110;
	 B = 4'b1010;

    // Suma
    op = 4'b0000;
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // Resta
    op = 4'b0001; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);
	 
	 // Multiplicación
    op = 4'b0010; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // División
    op = 4'b0011; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // AND
    op = 4'b0101; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // OR
    op = 4'b0110; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // XOR
    op = 4'b0111; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // Shift left
    op = 4'b1000; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // Shift right
    op = 4'b1001; 
	 #1;
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    $finish;
  end

endmodule

/*
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
   logic	p10, p11, p12, p13, p14, p15;
	
	
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
	
	//Quinta columna
	AND_gate and10(.a(A[3]), .b(B[1]), .y(p10));
	AND_gate and11(.a(A[2]), .b(B[2]), .y(p11));
	AND_gate and12(.a(A[1]), .b(B[3]), .y(p12));
	
	//Sexta columna
	AND_gate and13(.a(A[3]), .b(B[2]), .y(p13));
	AND_gate and14(.a(A[2]), .b(B[3]), .y(p14));
	
	//Septima columna
	AND_gate and15(.a(A[3]), .b(B[3]), .y(p15));
	
	
	
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
	
	//Quinto bit de P
	logic c7, c8, c9, s4, s5, pf;
	Full_Adder fa7 (.A(p10), .B(p11), .Cin(c4), .Sum(s4), .Cout(c7));
	Full_Adder fa8 (.A(s4), .B(p12), .Cin(c5), .Sum(s5), .Cout(c8));
	Full_Adder fa9 (.A(s5), .B(c6), .Cin(1'b0), .Sum(P[4]), .Cout(c9));
	
	//Sexto bit de P
	logic c10, c11, s6;
	Full_Adder fa10 (.A(p13), .B(c7), .Cin(c8), .Sum(s6), .Cout(c10));
	Full_Adder fa11 (.A(s6), .B(p14), .Cin(c9), .Sum(P[5]), .Cout(c11));
	
	//Septimo y octavo bit de P
	logic c12;
	Full_Adder fa12 (.A(p15), .B(c10), .Cin(c11), .Sum(P[6]), .Cout(P[7]));
	
	
	// Flags
   assign N = P[3];          // MSB
   assign Z = (P == 4'd0);   // Cuando todo es cero
   assign C = c6;            // El carry de salida
   assign V = (A[3] ^ B[3]) & (A[3] ^ P[3]); // Si se suman 2 y cambia el signo 

endmodule	
*/
