module ALU
	#(parameter width = 4)(
	input logic CLK,
	input logic [width-1:0] A,
	input logic [width-1:0] B,
	input logic [3:0] op,
	output logic [6:0] seg,        // display
	output logic [3:0] led_flags  // para las flags
);
	logic [width-1:0] Y;
	logic N, Z, C, V;
	
  
  Alu_control alu1 (.A(A), .B(B), .op(~op), .Y(Y), .N(N), .Z(Z), .C(C), .V(V));
  
  seg7_display(.Y(Y), .seg(seg));
  
  assign led_flags = {V, C, Z, N};
 
endmodule