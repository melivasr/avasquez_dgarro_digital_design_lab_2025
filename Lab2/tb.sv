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

    // Resta
    op = 4'b0001; 
	 #1;
	 
	 // Multiplicación
    op = 4'b0010; 
	 #1;

    // División
    op = 4'b0011; 
	 #1;

    // AND
    op = 4'b0101; 
	 #1;

    // OR
    op = 4'b0110; 
	 #1;

    // XOR
    op = 4'b0111; 
	 #1;

    // Shift left
    op = 4'b1000; 
	 #1;

    // Shift right
    op = 4'b1001; 
	 #1;
	 
	 
	 
	 
	 // Probamos otros algunos valores
    A = 4'b0110;
	 B = 4'b1010;

    // Suma
    op = 4'b0000;
	 #1;

    // Resta
    op = 4'b0001; 
	 #1;
	 
	 // Multiplicación
    op = 4'b0010; 
	 #1;

    // División
    op = 4'b0011; 
	 #1;

    // AND
    op = 4'b0101; 
	 #1;

    // OR
    op = 4'b0110; 
	 #1;

    // XOR
    op = 4'b0111; 
	 #1;

    // Shift left
    op = 4'b1000; 
	 #1;

    // Shift right
    op = 4'b1001; 
	 #1;

    $finish;
  end

endmodule