module ALU(
	input logic [3:0] A,
	input logic [3:0] B,
	input logic [3:0] op,
	output logic [3:0] Y,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);

	// Salidas individuales de cada módulo
   logic [3:0] y_sum, y_sub, y_mult, y_div, y_mod, y_and, y_xor, y_shiftl, y_shiftr ;
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
	Ripple_carry_adder4 suma (.A(A), .B(B), .Y(), .N(), .Z(), .C(), .V());
	
	Full_subtractor4 suma (.A(A), .B(B), .Y(), .N(), .Z(), .C(), .V());
	
	Ripple_carry_adder4 suma (.A(A), .B(B), .Y(), .N(), .Z(), .C(), .V());
	
	Ripple_carry_adder4 suma (.A(A), .B(B), .Y(), .N(), .Z(), .C(), .V());
	
	Ripple_carry_adder4 suma (.A(A), .B(B), .Y(), .N(), .Z(), .C(), .V());
	
	Ripple_carry_adder4 suma (.A(A), .B(B), .Y(), .N(), .Z(), .C(), .V());
	
	Ripple_carry_adder4 suma (.A(A), .B(B), .Y(), .N(), .Z(), .C(), .V());