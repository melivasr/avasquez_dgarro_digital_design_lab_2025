`timescale 1ns/1ps

module tb2;

  logic clk, reset;
  logic [1:0] A;
  logic [1:0] B;
  logic [3:0] op;
  logic [1:0] Y;
  logic N, Z, C, V;

  ALU2 #(.width(4)) dut (.clk(clk), .rst(reset), .A(A), .B(B), .op(op), .Y(Y));
  
  // Generate clk   100hz
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
  
	 reset = 1;
	 A = 0; 
	 B = 0;
	 op = 0;
	 #10
	 reset = 0;

    // Probamos algunos valores
    A = 4'b0101;
	 B = 2'b0011;

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
	 
    $finish;
  end

endmodule