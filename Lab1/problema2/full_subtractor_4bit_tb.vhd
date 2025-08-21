library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_subtractor_4bit_tb is
end full_subtractor_4bit_tb;

architecture sim of full_subtractor_4bit_tb is
    signal A, B   : std_logic_vector(3 downto 0) := (others => '0');
    signal Cin    : std_logic := '0';
    signal S      : std_logic_vector(3 downto 0);
    signal Cout   : std_logic;

    component full_subtractor_4bit
        Port (
            A    : in  std_logic_vector(3 downto 0);
            B    : in  std_logic_vector(3 downto 0);
            Cin  : in  std_logic;
            S    : out std_logic_vector(3 downto 0);
            Cout : out std_logic
        );
    end component;

begin
    DUT: full_subtractor_4bit
        port map (
            A => A,
            B => B,
            Cin => Cin,
            S => S,
            Cout => Cout);

    --Casos
    stim_proc: process
    begin
        --Caso 1:
        A <= "1010"; 
        B <= "1000"; 
        Cin <= '0';
        wait for 10 ns;

        --Caso 2:
        A <= "1010"; 
        B <= "1000"; 
        Cin <= '1';
        wait for 10 ns;

        --Caso 3:
        A <= "0000";
        B <= "1110";
        Cin <= '1';
        wait for 10 ns;

        --Caso 4:
        A <= "0000";
        B <= "1111";
        Cin <= '1';
        wait for 10 ns;
        wait;
    end process;

end sim;
