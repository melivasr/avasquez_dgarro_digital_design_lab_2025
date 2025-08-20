`timescale 1ns/1ps
module tb_param_counter;
    // clock 100 MHz
    logic clk = 0;
    always #5 clk = ~clk;

    // --- PRUEBA N=2 ---
    logic arst2, en2;
    logic [1:0] q2;
    counter_n #(.N(2)) u2 (.clk(clk), .arst(arst2), .en(en2), .load(1'b0), .d('0), .q(q2));

    initial begin
        $display("Probando contador N=2...");
        arst2 = 1; en2 = 0;
        repeat (2) @(posedge clk);
        arst2 = 0;
        repeat (4) begin
            en2 = 1; @(posedge clk);
            en2 = 0;
        end
        $display("OK N=2, valor final=%0d", q2);
    end

    // --- PRUEBA N=4 ---
    logic arst4, en4;
    logic [3:0] q4;
    counter_n #(.N(4)) u4 (.clk(clk), .arst(arst4), .en(en4), .load(1'b0), .d('0), .q(q4));

    initial begin
        $display("Probando contador N=4...");
        arst4 = 1; en4 = 0;
        repeat (2) @(posedge clk);
        arst4 = 0;
        repeat (8) begin
            en4 = 1; @(posedge clk);
            en4 = 0;
        end
        $display("OK N=4, valor final=%0d", q4);
    end

    // --- PRUEBA N=6 ---
    logic arst6, en6;
    logic [5:0] q6;
    counter_n #(.N(6)) u6 (.clk(clk), .arst(arst6), .en(en6), .load(1'b0), .d('0), .q(q6));

    initial begin
        $display("Probando contador N=6...");
        arst6 = 1; en6 = 0;
        repeat (2) @(posedge clk);
        arst6 = 0;
        repeat (10) begin
            en6 = 1; @(posedge clk);
            en6 = 0;
        end
        $display("OK N=6, valor final=%0d", q6);
        $finish;
    end
endmodule