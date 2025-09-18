module shift_left
	#(parameter width = 4)(
	input logic [width-1:0]a,
	input logic [width-1:0]b,    //desplazamiento
	output logic [width-1:0]y,
	output logic N,
   output logic Z,
   output logic C,
   output logic V
);				
	logic [width:0] temp;
	
	assign temp = {1'b0, a} << b;
	
	assign y = temp[width-1:0];
	
   assign N    = y[width-1];                // MSB
   assign Z    = (y == 4'd0);         // Si todos son 0
	assign C    = temp[width];             // último bit que salió a la izquierda
   assign V    = 1'b0;                // no tiene 
	
	
	
endmodule