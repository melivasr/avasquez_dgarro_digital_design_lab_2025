module ALU(
	input logic CLK,
	input logic [3:0] A,
	input logic [3:0] B,
	input logic [3:0] op,
	output logic [6:0] seg,        // display
	output logic [3:0] led_flags  // para las flags
);
	logic [3:0] Y;
	logic N, Z, C, V;
	
  
  Alu_control alu1 (.A(A), .B(B), .op(~op), .Y(Y), .N(N), .Z(Z), .C(C), .V(V));
  
  seg7_display(.Y(Y), .seg(seg));
  
  assign led_flags = {V, C, Z, N};
 
endmodule