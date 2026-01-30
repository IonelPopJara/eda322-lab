LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;

ENTITY cmp IS
    PORT (
        a : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        e : OUT STD_LOGIC);
END cmp;

ARCHITECTURE dataflow OF cmp IS
BEGIN
    e <= NOR_REDUCE(a XOR b);
END dataflow;