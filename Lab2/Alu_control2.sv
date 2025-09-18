module Alu_control2(
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0] op,
    output logic [31:0] Y,
    output logic N,
    output logic Z,
    output logic C,
    output logic V
);

    // Salidas individuales de cada módulo
    logic [31:0] y_sum, y_sub, y_mult, y_div, y_mod, y_and, y_or, y_xor, y_shiftl, y_shiftr;

    logic z_sum, n_sum, c_sum, v_sum;
	 
    logic z_sub, n_sub, c_sub, v_sub;
	 
    logic z_mult, n_mult, c_mult, v_mult;
	 
    logic z_div, n_div, c_div, v_div;
	 
    logic z_mod, n_mod, c_mod, v_mod;
	 
    logic z_and, n_and, c_and, v_and;  
	 
    logic z_or, n_or, c_or, v_or;
	 
    logic z_xor, n_xor, c_xor, v_xor;   
	 
    logic z_shiftl, n_shiftl, c_shiftl, v_shiftl;
	 
    logic z_shiftr, n_shiftr, c_shiftr, v_shiftr;
	 

    // Se instancia todo
	 
    Ripple_carry_adder32 suma (.A(A), .B(B), .Cin(1'b0), .Sum(y_sum), .N(n_sum), .Z(z_sum), .C(c_sum), .V(v_sum));

    Full_subtractor32 suba (.A(A), .B(B), .Cin(1'b0), .Sub(y_sub), .N(n_sub), .Z(z_sub), .C(c_sub), .V(v_sub));

    Multiplicacion32 multi (.A(A), .B(B), .P(y_mult), .N(n_mult), .Z(z_mult), .C(c_mult), .V(v_mult));

    Division #(31) diva (.a(A), .b(B), .y(y_div), .N(n_div), .Z(z_div), .C(c_div), .V(v_div));

    Modulo #(31) moda (.a(A), .b(B), .y(y_mod), .N(n_mod), .Z(z_mod), .C(c_mod), .V(v_mod));

    AND_gate #(31) anda (.a(A), .b(B), .y(y_and), .N(n_and), .Z(z_and), .C(c_and), .V(v_and));

    OR_gate #(31) ora (.a(A), .b(B), .y(y_or), .N(n_or), .Z(z_or), .C(c_or), .V(v_or));

    XOR_gate #(31) xora (.a(A), .b(B), .y(y_xor), .N(n_xor), .Z(z_xor), .C(c_xor), .V(v_xor));

    shift_left #(31) shiftl (.a(A), .b(B), .y(y_shiftl), .N(n_shiftl), .Z(z_shiftl), .C(c_shiftl), .V(v_shiftl));

    shift_right #(31) shiftr (.a(A), .b(B), .y(y_shiftr), .N(n_shiftr), .Z(z_shiftr), .C(c_shiftr), .V(v_shiftr));

    // Selectores
    logic sel_sum, sel_sub, sel_mult, sel_div, sel_mod, sel_and, sel_or, sel_xor, sel_shiftl, sel_shiftr;

    assign sel_sum = (op == 4'b0000);
    assign sel_sub = (op == 4'b0001);
    assign sel_mult = (op == 4'b0010);
    assign sel_div = (op == 4'b0011);
    assign sel_mod = (op == 4'b0100);
    assign sel_and = (op == 4'b0101);
    assign sel_or = (op == 4'b0110);
    assign sel_xor = (op == 4'b0111);
    assign sel_shiftl = (op == 4'b1000);
    assign sel_shiftr = (op == 4'b1001);

    // Selección de Y con un loop
    genvar i;
    generate
      for (i = 0; i < 32; i++) begin: loop
        assign Y[i] =
             (y_sum[i] & sel_sum)    |
             (y_sub[i] & sel_sub)    |
             (y_mult[i] & sel_mult)   |
             (y_div[i] & sel_div)    |
             (y_mod[i] & sel_mod)    |
             (y_and[i] & sel_and)    |
             (y_or[i] & sel_or)     |
             (y_xor[i] & sel_xor)    |
             (y_shiftl[i] & sel_shiftl) |
             (y_shiftr[i] & sel_shiftr);
      end
    endgenerate

    // Flags
    assign N = (n_sum & sel_sum) |
               (n_sub & sel_sub) |
               (n_mult & sel_mult) |
               (n_div & sel_div) |
               (n_mod & sel_mod) |
               (n_and & sel_and) |
               (n_or & sel_or) |
               (n_xor & sel_xor) |
               (n_shiftl & sel_shiftl) |
               (n_shiftr & sel_shiftr);

    assign Z = (z_sum & sel_sum) |
               (z_sub & sel_sub) |
               (z_mult & sel_mult) |
               (z_div & sel_div) |
               (z_mod & sel_mod) |
               (z_and & sel_and) |
               (z_or & sel_or) |
               (z_xor & sel_xor) |
               (z_shiftl & sel_shiftl) |
               (z_shiftr & sel_shiftr);

    assign C = (c_sum & sel_sum) |
               (c_sub & sel_sub) |
               (c_mult & sel_mult) |
               (c_div & sel_div) |
               (c_mod & sel_mod) |
               (c_and & sel_and) |
               (c_or & sel_or) |
               (c_xor & sel_xor) |
               (c_shiftl & sel_shiftl) |
               (c_shiftr & sel_shiftr);

    assign V = (v_sum & sel_sum) |
               (v_sub & sel_sub) |
               (v_mult & sel_mult) |
               (v_div & sel_div) |
               (v_mod & sel_mod) |
               (v_and & sel_and) |
               (v_or & sel_or) |
               (v_xor & sel_xor) |
               (v_shiftl & sel_shiftl) |
               (v_shiftr & sel_shiftr);

endmodule