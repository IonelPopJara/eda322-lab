LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.chacc_pkg.ALL;

ENTITY proc_controller IS
    PORT (
        clk : IN STD_LOGIC;
        resetn : IN STD_LOGIC;
        master_load_enable : IN STD_LOGIC;
        opcode : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        e_flag : IN STD_LOGIC;
        z_flag : IN STD_LOGIC;
        inValid : IN STD_LOGIC;
        outReady : IN STD_LOGIC;

        busSel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        pcSel : OUT STD_LOGIC;
        pcLd : OUT STD_LOGIC;
        imRead : OUT STD_LOGIC;
        dmRead : OUT STD_LOGIC;
        dmWrite : OUT STD_LOGIC;
        aluOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        flagLd : OUT STD_LOGIC;
        accSel : OUT STD_LOGIC;
        accLd : OUT STD_LOGIC;
        inReady : OUT STD_LOGIC;
        outValid : OUT STD_LOGIC
    );
END proc_controller;

ARCHITECTURE test OF proc_controller IS
BEGIN
END test;