library ieee;
use ieee.std_logic_1164.all;

entity tb_cmp is
end;

architecture sim of tb_cmp is
    signal a_val : std_logic_vector(7 downto 0);
    signal b_val : std_logic_vector(7 downto 0);
    signal E     : std_logic;
begin

    dut: entity work.CMP(execute)
        port map (
            a_val => a_val,
            b_val => b_val,
            E     => E
        );

    process
    begin
        -- Case 1: equal ? E = 1
        a_val <= "00000000";
        b_val <= "00000000";
        wait for 10 ns;

        -- Case 2: different ? E = 0
        a_val <= "00000001";
        b_val <= "00000000";
        wait for 10 ns;

        -- Case 3: equal ? E = 1
        a_val <= "10101010";
        b_val <= "10101010";
        wait for 10 ns;

        wait;   -- stop simulation
    end process;

end sim;

