module Full_Adder(
	input logic A
	input logic B
	input logic Cin
	output logic Sum
	output logic Cout
);

	logic xor1, xor2;
	
	// sum = a ^ b ^ c, primero a ^ b
	XOR xora (.a(A), .b(B), .y(xor1));
	
	XOR xorb (.a(xor1), .b(Cin), .y(Sum));
	
	
	
	logic and1, and2, or1;
	
	// Cout = AB + Cin(A^B)
	
	AND anda (.a(A), .b(B), .y(and1));
	
	AND andb(.a(Cin), .b(xor1), .y(and2));
	
	OR ora(.a(and1), .b(and2), .y(Cout));
	

endmodule