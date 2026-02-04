LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_cmp IS
END;

ARCHITECTURE sim OF tb_cmp IS
    SIGNAL a : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL b : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL E : STD_LOGIC;
BEGIN

    dut : ENTITY work.CMP
        PORT MAP(
            a => a,
            b => b,
            E => E
        );

    PROCESS
    BEGIN
        -- Case 1: equal ? E = 1
        a <= "00000000";
        b <= "00000000";
        WAIT FOR 10 ns;

        -- Case 2: different ? E = 0
        a <= "00000001";
        b <= "00000000";
        WAIT FOR 10 ns;

        -- Case 3: equal ? E = 1
        a <= "10101010";
        b <= "10101010";
        WAIT FOR 10 ns;

        WAIT; -- stop simulation
    END PROCESS;

END sim;