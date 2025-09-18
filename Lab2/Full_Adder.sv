module Full_Adder(
	input logic A,
	input logic B,
	input logic Cin,
	output logic Sum,
	output logic Cout
);

	logic xor1;
	
	// sum = a ^ b ^ c, primero a ^ b
	XOR_gate xora (.a(A),    .b(B),   .y(xor1));
	
	XOR_gate xorb (.a(xor1), .b(Cin), .y(Sum));
	
	
	
	logic and1, and2;
	
	// Cout = AB + Cin(A^B)
	
	AND_gate anda (.a(A),  .b(B),    .y(and1));
	
	AND_gate andb(.a(Cin), .b(xor1), .y(and2));
	
	OR_gate ora(.a(and1),  .b(and2), .y(Cout));
	

endmodule