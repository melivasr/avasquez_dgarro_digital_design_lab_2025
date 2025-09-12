module AND_gate
	#(parameter width = 4)(
	input logic [width-1:0]a,
	input logic [width-1:0]b,
	output logic [width-1:0]y,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);		

	assign y = a & b;
	
	//flags 
	assign N = y[3];       //MSB
	assign Z = (y == 4'd0); //y en cero
	assign C = 1'b0;        //Sin carry
	assign V = 1'b0;       //Sin Overflow
	
endmodule