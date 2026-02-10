LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.chacc_pkg.ALL;

ENTITY memory IS
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
END ENTITY;

ARCHITECTURE behavioral OF memory IS
    -- CONSTANT NUMBER_OF_ENTRIES : INTEGER := 2 ** DATA_WIDTH;

    -- OLD (Incorrect): CONSTANT NUMBER_OF_ENTRIES : INTEGER := 2 ** DATA_WIDTH;
    CONSTANT NUMBER_OF_ENTRIES : INTEGER := 2 ** ADDR_WIDTH;

    TYPE MEMORY_ARRAY IS ARRAY (0 TO NUMBER_OF_ENTRIES - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

    IMPURE FUNCTION init_memory_wfile(mif_file_name : IN STRING) RETURN MEMORY_ARRAY IS
        FILE mif_file : text OPEN read_mode IS mif_file_name;
        VARIABLE mif_line : line;
        VARIABLE temp_bv : bit_vector(DATA_WIDTH - 1 DOWNTO 0);
        VARIABLE temp_mem : MEMORY_ARRAY;
    BEGIN
        FOR i IN MEMORY_ARRAY'RANGE LOOP
            readline(mif_file, mif_line);
            read(mif_line, temp_bv);
            temp_mem(i) := to_stdlogicvector(temp_bv);
        END LOOP;
        RETURN temp_mem;
    END FUNCTION;

    SIGNAL RAM : MEMORY_ARRAY := init_memory_wfile(INIT_FILE);

BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF writeEn = '1' THEN
                -- write from data in to memory
                RAM(to_integer(unsigned(address))) <= dataIn;
            ELSE
                IF readEn = '1' THEN
                    -- read from memory to data out
                    dataOut <= RAM(to_integer(unsigned(address)));
                END IF;
            END IF;
        END IF;
    END PROCESS;
END behavioral;