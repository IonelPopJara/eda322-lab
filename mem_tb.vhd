LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.chacc_pkg.ALL;

ENTITY mem_tb IS
END ENTITY;

ARCHITECTURE sim OF rca_tb IS
    SIGNAL a_val : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL b_val : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL carry_in : STD_LOGIC;
    SIGNAL sum : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL carry_out : STD_LOGIC;
    clk : IN STD_LOGIC;
    readEn : IN STD_LOGIC;
    writeEn : IN STD_LOGIC;
    address : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    dataIn : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    dataOut : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
BEGIN

    GENERIC (
        DATA_WIDTH : INTEGER := 8;
        ADDR_WIDTH : INTEGER := 8;
        INIT_FILE : STRING := "memory.mif");
    PORT (
        clk : IN STD_LOGIC;
        readEn : IN STD_LOGIC;
        writeEn : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        dataIn : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        dataOut : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END ARCHITECTURE;