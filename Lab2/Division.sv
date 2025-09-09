module Division(
	input logic [3:0] a,
	input logic [3:0] b,
	output logic [3:0] y,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);		

	assign y = a / b;
	
	// Flags
   assign N = y[3];          // MSB
   assign Z = (y == 4'd0);   // Cuando todo es cero
   assign C = 1'b0           // El carry de salida 0
   assign V = 1'b0           // No tiene overflow
	
endmodule