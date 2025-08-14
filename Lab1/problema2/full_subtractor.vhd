library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_subtractor is 
	port(A, B, Cin: in std_logic; S, Cout: out std_logic);
	
end full_subtractor;

architecture Estructural of full_subtractor is 

	signal xor1_out, xor2_out, xor3_out: std_logic;
   signal notA, not_xor3, and1_out, and2_out: std_logic;
   signal or1_out: std_logic;
	
begin 
	
	xor1_out <= A xor B;
	xor2_out <= Cin xor xor1_out;
	S <= xor2_out;
	
	notA <= not A;
	and1_out <= notA and B;
	xor3_out <= A xor B;
	not_xor3 <= not xor3_out;
	and2_out <= Cin and not_xor3;
	or1_out <= and1_out or and2_out;
	
	Cout <= or1_out;
	
end Estructural;