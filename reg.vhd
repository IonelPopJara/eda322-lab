LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg IS
    GENERIC (width : INTEGER := 8);
    PORT (
        clk, rstn, en : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
    );
END ENTITY reg;

ARCHITECTURE structural OF reg IS
BEGIN
    PROCESS (rstn, clk)
    BEGIN
        IF rstn = '0' THEN
            q <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF en = '1' THEN
                q <= d;
            END IF;
        END IF;
    END PROCESS;
END structural;