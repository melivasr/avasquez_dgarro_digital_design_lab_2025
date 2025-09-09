`timescale 1ns/1ps
module tb;

  // señales
  logic [3:0] a, b;
  logic [3:0] y;

  // instancia del DUT
  Division dut (
    .a(a),
    .b(b),
    .y(y)
  );

  initial begin
    $display(" a   b  |  y (a/b esperado)");
    $display("---------------------------");

    // Caso 1: 8 / 2 = 4
    a = 4'd8; b = 4'd2; #5;
    $display("%2d  %2d |  %2d", a, b, y);

    // Caso 2: 7 / 3 = 2 (parte entera)
    a = 4'd7; b = 4'd3; #5;
    $display("%2d  %2d |  %2d", a, b, y);

    // Caso 3: 15 / 4 = 3
    a = 4'd15; b = 4'd4; #5;
    $display("%2d  %2d |  %2d", a, b, y);

    // Caso 4: 9 / 5 = 1
    a = 4'd9; b = 4'd5; #5;
    $display("%2d  %2d |  %2d", a, b, y);

    // Caso 5: 3 / 0 (indefinido → X o 0 según simulador)
    a = 4'd3; b = 4'd0; #5;
    $display("%2d  %2d |  %2d  <-- cuidado: división por cero", a, b, y);

    $stop;
  end

endmodule