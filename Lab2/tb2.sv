`timescale 1ns/1ps

module tb2;
  logic clk, reset;
  logic [31:0] A;
  logic [31:0] B;
  logic [3:0] op;
  logic [31:0] Y;
  logic N, Z, C, V;

  ALU2 alu (.clk(clk), .reset(reset), .A(A), .B(B), .op(op), .Y(Y));
  
  // Generate clk   100hz
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
  
	 reset = 1;
	 A = 32'd0; 
	 B = 32'd0;
	 op = 4'd0;
	 
	 @(posedge clk);
	 @(posedge clk);
	 reset = 0;
	 

    // Probamos algunos valores
    A = 32'd2730;
	 B = 32'd341;
	 
	 @(posedge clk);
	
    // Suma
    op = 4'b0000;
	 @(posedge clk);

    $display("%2d  %2d  %b | %2d   %b %b %b %b" , A, B, op, Y, N, Z, C, V);

    // Resta
    op = 4'b0001; 
	 @(posedge clk);
	 
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);
	 
	 // Multiplicación
    op = 4'b0010; 
	 @(posedge clk);
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // División
    op = 4'b0011; 
	 @(posedge clk);
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // AND
    op = 4'b0101; 
	 @(posedge clk);
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // OR
    op = 4'b0110; 
	 @(posedge clk);
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // XOR
    op = 4'b0111; 
	 @(posedge clk);
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // Shift left
    op = 4'b1000; 
	 @(posedge clk);
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);

    // Shift right
    op = 4'b1001; 
	 @(posedge clk);
    $display("%2d  %2d  %b | %2d   %b %b %b %b", A, B, op, Y, N, Z, C, V);
	 
    $finish;
  end

endmodule