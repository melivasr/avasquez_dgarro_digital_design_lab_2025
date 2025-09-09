module ALU(
	input logic [3:0] A,
	input logic [3:0] B,
	input logic [3:0] op,
	output logic [3:0] Y,
	output logic [6:0] seg,  //display
	output logic N,
   output logic Z,
   output logic C,
   output logic V,
	output logic [3:0] led_flags
);

	// Salidas individuales de cada módulo
   logic [3:0] y_sum, y_sub, y_mult, y_div, y_mod, y_and, y_or, y_xor, y_shiftl, y_shiftr ;
	
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
	
   
	//Se instancia todo
	Ripple_carry_adder4 suma (.A(A), .B(B), .Cin(1'b0), .Sum(y_sum), .N(n_sum), .Z(z_sum), .C(c_sum), .V(v_sum));
	
	Full_subtractor4 suba (.A(A), .B(B), .Cin(1'b0), .Sub(y_sub), .N(n_sub), .Z(z_sub), .C(c_sub), .V(v_sub));
	
	//Multiplicacion multi (.A(A), .B(B), .Y(y_mult), .N(n_mult), .Z(z_mult), .C(c_mult), .V(v_mult));
	
	Division diva (.a(A), .b(B), .y(y_div), .N(n_div), .Z(z_div), .C(c_div), .V(v_div));
	
	Modulo moda (.a(A), .b(B), .y(y_mod), .N(n_mod), .Z(z_mod), .C(c_mod), .V(v_mod));
	
	AND_gate anda (.a(A), .b(B), .y(y_and), .N(n_and), .Z(z_and), .C(c_and), .V(v_and));
	
	OR_gate ora (.a(A), .b(B), .y(y_or), .N(n_or), .Z(z_or), .C(c_or), .V(v_or));
	
	XOR_gate xora (.a(A), .b(B), .y(y_xor), .N(n_xor), .Z(z_xor), .C(c_xor), .V(v_xor));
	
	shift_left shiftl (.a(A), .b(B), .y(y_shiftl), .N(n_shiftl), .Z(z_shiftl), .C(c_shiftl), .V(v_shiftl));
	
	shift_right shiftr (.a(A), .b(B), .y(y_shiftr), .N(n_shiftr), .Z(z_shiftr), .C(c_shiftr), .V(v_shiftr));
	
	
	// Selector de cada bit basado en op[3:0]
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
	
	//Se arma el Y[0], es 1 solo cuando su selector es 1 
	assign Y[0] = (y_sum[0] & sel_sum)    |
                 (y_sub[0] & sel_sub)    |
                 (y_mult[0] & sel_mult)   |
                 (y_div[0] & sel_div)    |
                 (y_mod[0] & sel_mod)    |
                 (y_and[0] & sel_and)    |
                 (y_or[0] & sel_or)     |
                 (y_xor[0] & sel_xor)    |
                 (y_shiftl[0] & sel_shiftl) |
                 (y_shiftr[0] & sel_shiftr);	
	 
	 //Se arma el Y[1], es 1 solo cuando su selector es 1 
	assign Y[1] = (y_sum[1] & sel_sum)    |
                 (y_sub[1] & sel_sub)    |
                 (y_mult[1] & sel_mult)   |
                 (y_div[1] & sel_div)    |
                 (y_mod[1] & sel_mod)    |
                 (y_and[1] & sel_and)    |
                 (y_or[1] & sel_or)     |
                 (y_xor[1] & sel_xor)    |
                 (y_shiftl[1] & sel_shiftl) |
                 (y_shiftr[1] & sel_shiftr);	
					  
	//Se arma el Y[2], es 1 solo cuando su selector es 1 
	assign Y[2] = (y_sum[2] & sel_sum)    |
                 (y_sub[2] & sel_sub)    |
                 (y_mult[2] & sel_mult)   |
                 (y_div[2] & sel_div)    |
                 (y_mod[2] & sel_mod)    |
                 (y_and[2] & sel_and)    |
                 (y_or[2] & sel_or)     |
                 (y_xor[2] & sel_xor)    |
                 (y_shiftl[2] & sel_shiftl) |
                 (y_shiftr[2] & sel_shiftr);	

	//Se arma el Y[3], es 1 solo cuando su selector es 1 
	assign Y[3] = (y_sum[3] & sel_sum)    |
                 (y_sub[3] & sel_sub)    |
                 (y_mult[3] & sel_mult)   |
                 (y_div[3] & sel_div)    |
                 (y_mod[3] & sel_mod)    |
                 (y_and[3] & sel_and)    |
                 (y_or[3] & sel_or)     |
                 (y_xor[3] & sel_xor)    |
                 (y_shiftl[3] & sel_shiftl) |
                 (y_shiftr[3] & sel_shiftr);	
	
	// Lo mismo pero para las flags, escogiendo cual son las que se muestran
	assign N = (n_sum & sel_sum) |
              (n_sub & sel_sub) |
              (n_mult & sel_mult) |
			     (n_div & sel_div)   |
			     (n_mod & sel_mod)   |
			     (n_and & sel_and)   |
			     (n_or & sel_or)   |
			     (n_xor & sel_xor)   |
			     (n_shiftl & sel_shiftl)   |
			     (n_shiftr & sel_shiftr);
	
	assign Z = (z_sum & sel_sum) |
              (z_sub & sel_sub) |
              (z_mult & sel_mult) |
			     (z_div & sel_div)   |
			     (z_mod & sel_mod)   |
			     (z_and & sel_and)   |
			     (z_or & sel_or)   |
			     (z_xor & sel_xor)   |
			     (z_shiftl & sel_shiftl)   |
			     (z_shiftr & sel_shiftr);
	
	assign C = (c_sum & sel_sum) |
              (c_sub & sel_sub) |
              (c_mult & sel_mult) |
			     (c_div & sel_div)   |
			     (c_mod & sel_mod)   |
			     (c_and & sel_and)   |
			     (c_or & sel_or)   |
			     (c_xor & sel_xor)   |
			     (c_shiftl & sel_shiftl)   |
			     (c_shiftr & sel_shiftr);
	
	assign V = (v_sum & sel_sum) |
              (v_sub & sel_sub) |
              (v_mult & sel_mult) |
			     (v_div & sel_div)   |
			     (v_mod & sel_mod)   |
			     (v_and & sel_and)   |
			     (v_or & sel_or)   |
			     (v_xor & sel_xor)   |
			     (v_shiftl & sel_shiftl)   |
			     (v_shiftr & sel_shiftr);
	
	
	
	7seg_display display(.Y(Y), .seg(seg));
	
	assign led_flags = {N, Z, C, V};
	
endmodule
	
	
	