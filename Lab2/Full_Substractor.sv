module Full_Substractor (
	input logic A
	input logic B
	input logic Cin
	output logic Sub
	output logic Cout
);
	
	logic xor1;
	
	// S = Cin ^ (A ^ b)
	XOR xora(.a(A), .b(B), .y(xor1));
	
	XOR xorb(.a(Cin), .b(xor1), .y(Sub));
	
	
	logic and1, and2, nA, nxor1;
	
	// Cout = Cin~(a^b)+(~ab)
	
	NOT nota(.a(A), .y(nA));
	
	NOT notb(.a(xor1), .y(nxor1));
	
	
	AND and1(.a(Cin), .b(nxor1), .y(and1));
	
	AND and2(.a(nA), .b(B), .y(and2));
	
	OR or1(.a(and1), .b(and2), .y(Cout));

endmodule