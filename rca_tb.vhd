library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rca_tb is
end entity;

architecture sim of rca_tb is
  signal a_val     : std_logic_vector(3 downto 0);
  signal b_val     : std_logic_vector(3 downto 0);
  signal carry_in  : std_logic;
  signal sum       : std_logic_vector(3 downto 0);
  signal carry_out : std_logic;
begin

  dut: entity work.rca
    port map (
      A     => a_val,
      B    => b_val,
      cin  => carry_in,
      O       => sum,
      cout => carry_out
    );

  stim: process
  begin
    -- Test case: 5 + 7 + 1 = 13 (1101)
    a_val    <= "0101"; -- 5
    b_val    <= "0111"; -- 7
    carry_in <= '1';
    wait for 50 ns;

    -- Test case: 9 + 6 = 15
    a_val    <= "1001"; -- 9
    b_val    <= "0110"; -- 6
    carry_in <= '0';
    wait for 50 ns;

    wait;
  end process;

end architecture;