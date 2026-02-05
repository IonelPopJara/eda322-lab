LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.chacc_pkg.ALL;

ENTITY mem_tb IS
END ENTITY;

ARCHITECTURE sim OF mem_tb IS
    CONSTANT DATA_WIDTH : INTEGER := 8;
    CONSTANT ADDR_WIDTH : INTEGER := 8;
    CONSTANT INIT_FILE : STRING := "d_memory_lab2.mif";

    -- signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL readEn : STD_LOGIC := '0';
    SIGNAL writeEn : STD_LOGIC := '0';
    SIGNAL address : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dataIn : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dataOut : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

    CONSTANT CLK_PERIOD : TIME := 20ns;
BEGIN
    DUT : ENTITY work.memory
        GENERIC MAP(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH,
            INIT_FILE => INIT_FILE
        )
        PORT MAP(
            clk => clk,
            readEn => readEn,
            writeEn => writeEn,
            address => address,
            dataIn => dataIn,
            dataOut => dataOut
        );

    clk_get : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR CLK_PERIOD/2;
            clk <= '1';
            WAIT FOR CLK_PERIOD/2;
        END LOOP;
    END PROCESS;

    simu : PROCESS
    BEGIN
        address <= "00000000";
        dataIn <= "01010101";
        writeEn <= '1';
        readEn <= '0';
        WAIT FOR 100ns;
        address <= "00000000";
        readEn <= '1';
        writeEn <= '0';
        WAIT FOR 100ns;
        address <= "00000001";
        dataIn <= "11110000";
        writeEn <= '1';
        readEn <= '0';
        WAIT FOR 100ns;
        address <= "00000001";
        readEn <= '1';
        writeEn <= '0';
        WAIT FOR 100ns;
    END PROCESS;
END ARCHITECTURE;