LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.chacc_pkg.ALL;

ENTITY proc_bus IS
    PORT (
        busSel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        imDataOut : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dmDataOut : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        accOut : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        extIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        busOut : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END proc_bus;

ARCHITECTURE behavioral OF proc_bus IS
BEGIN
    busOut <= imDataOut WHEN busSel(0) = '1' ELSE
        (OTHERS => 'Z');
    busOut <= dmDataOut WHEN busSel(1) = '1' ELSE
        (OTHERS => 'Z');
    busOut <= accOut WHEN busSel(2) = '1' ELSE
        (OTHERS => 'Z');
    busOut <= extIn WHEN busSel(3) = '1' ELSE
        (OTHERS => 'Z');
    -- option 2
    -- busOut <= imDataOut WHEN busSel = "0001" ELSE
    --     (OTHERS => 'Z');
    -- busOut <= dmDataOut WHEN busSel = "0010" ELSE
    --     (OTHERS => 'Z');
    -- busOut <= accOut WHEN busSel = "0100" ELSE
    --     (OTHERS => 'Z');
    -- busOut <= extIn WHEN busSel = "1000" ELSE
    --     (OTHERS => 'Z');

    -- incorrect
    -- WITH busSel SELECT busOut <=
    -- imDataOut WHEN "0001",
    -- dmDataOut WHEN "0010",
    -- accOut WHEN "0100",
    -- extIn WHEN "1000",
    -- (OTHERS => 'Z') WHEN OTHERS;
END behavioral;