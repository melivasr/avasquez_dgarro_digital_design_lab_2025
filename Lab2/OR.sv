module OR_gate(
	input logic  [3:0]a,
	input logic  [3:0]b,
	output logic [3:0]y,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);			

	assign y = a | b;
	
	//flags 
	assign N = y[3];       //MSB
	assign Z = (y == 4'd0) //y en cero
	assign C = 1'b0        //Sin carry
	assign V = 1'b0        //Sin Overflow
	
endmodule