`timescale 1ns/1ps

module tb;

  logic [3:0] A, B;
  logic [3:0] op;
  logic [3:0] Y;
  logic N,Z,C,V;

  // Instancia de la ALU
  ALU dut (
    .A(A), .B(B), .op(op),
    .Y(Y), .N(N), .Z(Z), .C(C), .V(V)
  );

  initial begin
    $display("time | op | A | B |  Y  | N Z C V");
    $display("---------------------------------");

    // Prueba con algunos valores fijos de A y B
    A = 4'd5;  B = 4'd3; // 5 y 3 en decimal
    for (int i = 0; i < 10; i++) begin
      op = i; #5; // espera 5 ns
      $display("%4t | %02d | %d | %d | %2d | %b %b %b %b",
               $time, op, A, B, Y, N,Z,C,V);
    end

    // Cambiar valores de entrada
    A = 4'd7;  B = 4'd2;
    for (int i = 0; i < 10; i++) begin
      op = i; #5;
      $display("%4t | %02d | %d | %d | %2d | %b %b %b %b",
               $time, op, A, B, Y, N,Z,C,V);
    end

    // Otra combinación
    A = 4'd8;  B = 4'd0; // caso especial para DIV/MOD
    for (int i = 0; i < 10; i++) begin
      op = i; #5;
      $display("%4t | %02d | %d | %d | %2d | %b %b %b %b",
               $time, op, A, B, Y, N,Z,C,V);
    end

    $stop;
  end

endmodule