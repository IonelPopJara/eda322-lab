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
    WITH busSel SELECT busOut <=
    imDataOut WHEN "0001",
    dmDataOut WHEN "0010",
    accOut WHEN "0100",
    extIn WHEN "1000",
    (OTHERS => 'Z') WHEN OTHERS;
END behavioral;