module Modulo
	#(parameter width = 4)(
	input logic [width-1:0] a,
	input logic [width-1:0] b,
	output logic [width-1:0] y,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);	

	assign y = a % b;
	
	// Flags
   assign N = y[3];          // MSB
   assign Z = (y == 4'd0);   // Cuando todo es cero
   assign C = 1'b0;           // El carry de salida 0
   assign V = 1'b0;           // No tiene overflow
	
endmodule