module Full_Substractor (
	input logic A,
	input logic B,
	input logic Cin,
	output logic Sub,
	output logic Cout
);
	
	logic xor1;
	
	// S = Cin ^ (A ^ b)
	XOR_gate xora(.a(A), .b(B), .y(xor1));
	
	XOR_gate xorb(.a(xor1), .b(Cin), .y(Sub));
	
	
	logic and1, and2, nA, nxor1;
	
	// Cout = Cin~(a^b)+(~ab)
	
	NOT_gate nota(.a(A), .y(nA));
	
	NOT_gate notb(.a(xor1), .y(nxor1));
	
	
	AND_gate anda(.a(nA), .b(B), .y(and1));
	
	AND_gate andb(.a(Cin), .b(nxor1), .y(and2));
	
	OR_gate or1(.a(and1), .b(and2), .y(Cout));

endmodule