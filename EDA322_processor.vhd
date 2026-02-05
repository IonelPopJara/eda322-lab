LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY EDA322_processor IS
    GENERIC (
        dInitFile : STRING := "d_memory_lab2.mif";
        iInitFile : STRING := "i_memory_lab2.mif");
    PORT (
        clk : IN STD_LOGIC;
        resetn : IN STD_LOGIC;
        master_load_enable : IN STD_LOGIC;
        extIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        inValid : IN STD_LOGIC;
        outReady : IN STD_LOGIC;
        pc2seg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        imDataOut2seg : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        dmDataOut2seg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        aluOut2seg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        acc2seg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        busOut2seg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        extOut : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        inReady : OUT STD_LOGIC;
        outValid : OUT STD_LOGIC
    );
END EDA322_processor;

ARCHITECTURE structural OF EDA322_processor IS
    SIGNAL pcLd : STD_LOGIC;
    SIGNAL pcIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL pcOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL accLd : STD_LOGIC;
    SIGNAL accIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL accOut : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL flagLd : STD_LOGIC;

    SIGNAL aluOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL aluOut : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL currPC : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL offset : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL busSel : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL imRead : STD_LOGIC;
    SIGNAL dmRead : STD_LOGIC;
    SIGNAL dmWrite : STD_LOGIC;
    SIGNAL address : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL imDataOutFull : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL accOut : STD_LOGIC_VECTOR(8)
    -- d => nextPC,
    -- q => pcOut,
BEGIN

    PC : ENTITY work.reg(structural)
        GENERIC MAP(width => 8)
        PORT MAP(
            clk => clk,
            rstn => resetn,
            en => pcLd,
            d => pcIn,
            q => pcOut,
        );

    ACC : ENTITY work.reg(structural)
        GENERIC MAP(width => 8)
        PORT MAP(
            clk => clk,
            rstn => resetn,
            en => accLd,
            d => accIn,
            q => accOut,
        );

    E : ENTITY work.reg(structural)
        GENERIC MAP(width => 1)
        PORT MAP(
            clk => clk,
            rstn => resetn,
            en => flagLd,
            d => EIn,
            q => EOut,
        );

    Z : ENTITY work.reg(structural)
        GENERIC MAP(width => 1)
        PORT MAP(
            clk => clk,
            rstn => resetn,
            en => flagLd,
            d => ZIn,
            q => ZOut,
        );

    ALU : ENTITIY work.alu(structural)

    GENERIC MAP(
        width => 8
    )
    PORT MAP(
        alu_inA => busOut,
        alu_inB => accOut,
        alu_op => aluOp,
        E => EIn,
        Z => ZIn,
        alu_out => aluOut,
    );

    InMEM : ENTITY work.memory(behavioral)
        GENERIC MAP(
            DATA_WIDTH => 8,
            ADDR_WIDTH => 12,
            INIT_FILE => iInitFile
        )
        PORT MAP(
            clk => clk,
            readEn => imRead,
            writeEn => '0',
            address => pcOut,
            dataIn => OPEN,
            dataOut => imDataOutFull
        );

    DataMEM : ENTITY work.memory(behavioral)
        GENERIC MAP(
            DATA_WIDTH => 8,
            ADDR_WIDTH => 8,
            INIT_FILE => dInitFile
        )
        PORT MAP(
            clk => clk,
            readEn => dmRead,
            writeEn => dmWrite,
            address => busOut,
            dataIn => OPEN,
            dataOut => imDataOutFull
        );

    InterBus : ENTITY work.proc_bus(behavioral)
        PORT MAP(
            busSel => busSel,
            imDataOut = >,
            dmDataOut = >,
            accOut = >,
            extIn = >,
            busOut = >,
        );

    pcIncr : ENTITY work.rca(structural)
        GENERIC MAP(width => 8)
        PORT MAP(
            A => currPC, -- current address
            B => '00000000', -- increment of 1
            cin => '1', -- increment by 1
            cout => OPEN,
            O => pcIncrOut
        );

    -- decide whether to add or subtract
    -- use a mask to convert the offSet if needed

    jmpAddr : ENTITY work.rca(structural)
        GENERIC MAP(width => 8)
        PORT MAP(
            A => currPC, -- first 4 bits of A
            B => offset, -- first 4 bits of B
            cin => '0', -- actual carry in of the csa
            cout => OPEN,
            O => l_O
        );
END structural;