module ALU(
	input logic [3:0] switches,
	input logic mode,
	input logic CLK,
	input logic [3:0] op,
	output logic [6:0] seg,        // display
	output logic [3:0] led_flags  // para las flags
);
	logic [3:0] Y;
	logic [3:0] A;
	logic [3:0] B;
	logic [3:0] sw_val;
	logic N, Z, C, V;
	
	// Para capturar los switches de A y B
	always_ff @(posedge CLK) begin
    if (mode == 1'b0)
      A <= sw_val;
    else
      B <= sw_val;
   end
  
  
  Alu_control alu1 (.A(A), .B(B), .op(op), .Y(Y), .N(N), .Z(Z), .C(C), .V(V));
  
  seg7_display(.Y(Y), .seg(seg));
  
  assign led_flags = {N,Z,C,V};
 
endmodule