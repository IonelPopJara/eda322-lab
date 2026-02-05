LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;

LIBRARY work;
USE work.chacc_pkg.ALL;

ENTITY alu IS
    GENERIC (width : INTEGER := 8);
    PORT (
        alu_inA, alu_inB : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        alu_op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        E, Z : OUT STD_LOGIC;
        alu_out : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
    );
END alu;

ARCHITECTURE structural OF alu IS
    SIGNAL add_res : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    SIGNAL xor_res : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    SIGNAL and_res : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    SIGNAL mux_res : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    SIGNAL mask : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    SIGNAL test : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
BEGIN
    mask <= (OTHERS => alu_op(0)); -- the clanker recommended this to be safe instead of what I had before
    test <= alu_inB XOR mask;
    CSA : ENTITY work.csa(structural)
        PORT MAP(
            A => alu_inA,
            -- B => alu_inB XOR STD_LOGIC_VECTOR(OTHERS => alu_op(0)),
            B => test,
            cin => alu_op(0),
            cout => OPEN,
            O => add_res
        );

    CMP : ENTITY work.cmp(dataflow)
        PORT MAP(
            a => alu_inA,
            b => alu_inB,
            e => E
        );

    xor_res <= alu_inA XOR alu_inB;
    and_res <= alu_inA AND alu_inB;

    WITH alu_op SELECT mux_res <=
    xor_res WHEN "00",
    and_res WHEN "01",
    add_res WHEN OTHERS;

    alu_out <= mux_res;

    Z <= NOR_REDUCE(mux_res);

END structural;