library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_full_subtractor is
end tb_full_subtractor;

architecture Behavioral of tb_full_subtractor is
    -- Component Declaration for the Unit Under Test (UUT)
    component full_subtractor
        port(
            A, B, Cin : in std_logic;
            Cout, S : out std_logic
        );
    end component;

    -- Inputs
    signal A, B, Cin : std_logic := '0';
    
    -- Outputs
    signal Cout, S : std_logic;
    
    -- Clock period definitions (opcional)
    constant clock_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: full_subtractor port map (
        A => A,
        B => B,
        Cin => Cin,
        Cout => Cout,
        S => S
    );

    -- Stimulus process
    stim_proc: process
    begin        
        -- Test case 1: 0 - 0 - 0 = 0 (borrow 0)
        A <= '0'; B <= '0'; Cin <= '0';
        wait for clock_period;
        
        -- Test case 2: 0 - 0 - 1 = 1 (borrow 1)
        A <= '0'; B <= '0'; Cin <= '1';
        wait for clock_period;
        
        -- Test case 3: 0 - 1 - 0 = 1 (borrow 1)
        A <= '0'; B <= '1'; Cin <= '0';
        wait for clock_period;
        
        -- Test case 4: 0 - 1 - 1 = 0 (borrow 1)
        A <= '0'; B <= '1'; Cin <= '1';
        wait for clock_period;
        
        -- Test case 5: 1 - 0 - 0 = 1 (borrow 0)
        A <= '1'; B <= '0'; Cin <= '0';
        wait for clock_period;
        
        -- Test case 6: 1 - 0 - 1 = 0 (borrow 0)
        A <= '1'; B <= '0'; Cin <= '1';
        wait for clock_period;
        
        -- Test case 7: 1 - 1 - 0 = 0 (borrow 0)
        A <= '1'; B <= '1'; Cin <= '0';
        wait for clock_period;
        
        -- Test case 8: 1 - 1 - 1 = 1 (borrow 1)
        A <= '1'; B <= '1'; Cin <= '1';
        wait for clock_period;
        
        -- Final wait
        wait;
    end process;

end Behavioral;