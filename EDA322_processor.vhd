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
    -- Controller Signals
    SIGNAL pcLd : STD_LOGIC;
    SIGNAL pcSel : STD_LOGIC;
    SIGNAL accLd : STD_LOGIC;
    SIGNAL accSel : STD_LOGIC;
    SIGNAL flagLd : STD_LOGIC;
    SIGNAL imRead : STD_LOGIC;
    SIGNAL dmRead : STD_LOGIC;
    SIGNAL dmWrite : STD_LOGIC;
    SIGNAL aluOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL busSel : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- Internal Signals
    SIGNAL nextPc : STD_LOGIC_VECTOR(7 DOWNTO 0); -- input of the PC
    SIGNAL pcOut : STD_LOGIC_VECTOR(7 DOWNTO 0); -- output of the PC
    SIGNAL pcIncrOut : STD_LOGIC_VECTOR(7 DOWNTO 0); -- output from the incr adder BEFORE the PC Sel
    SIGNAL jumpAddr : STD_LOGIC_VECTOR(7 DOWNTO 0); -- output from the jump adder BEFORE the PC Sel
    SIGNAL busOut : STD_LOGIC_VECTOR(7 DOWNTO 0); -- full bus out
    SIGNAL offset : STD_LOGIC_VECTOR(7 DOWNTO 0); -- this is one of the inputs of the jump adder
    SIGNAL imDataOutFull : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL imDataOutController : STD_LOGIC_VECTOR(3 DOWNTO 0); -- opcode to the controller
    SIGNAL imDataOutBus : STD_LOGIC_VECTOR(7 DOWNTO 0); -- address to the bus
    SIGNAL accIn : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL accOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL dmDataOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL aluOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL aluOutFlagE : STD_LOGIC; -- input of the E register
    SIGNAL aluOutFlagZ : STD_LOGIC; -- input of the Z register
    SIGNAL flagEOut : STD_LOGIC; -- output of the E register
    SIGNAL flagZOut : STD_LOGIC; -- output of the Z register

    -- Signals for the jump address calculation
    SIGNAL mask : STD_LOGIC_VECTOR(7 DOWNTO 0); -- mask for the offset in the jump instruction, used to decide whether to add or subtract the offset
    SIGNAL jumpAddrInputB : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL test1 : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL test2 : STD_LOGIC_VECTOR(0 DOWNTO 0);

    SIGNAL test3 : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL test4 : STD_LOGIC_VECTOR(0 DOWNTO 0);
BEGIN

    CONTROLLER : ENTITY work.proc_controller(test)
        PORT MAP(
            -- in
            clk => clk,
            resetn => resetn,
            master_load_enable => master_load_enable,
            opcode => imDataOutController, --imdataout last part
            e_flag => flagEOut,
            z_flag => flagZOut,
            inValid => inValid,
            outReady => outReady,

            -- out
            busSel => busSel,
            pcSel => pcSel,
            pcLd => pcLd,
            imRead => imRead,
            dmRead => dmRead,
            dmWrite => dmWrite,
            aluOp => aluOp,
            flagLd => flagLd,
            accSel => accSel,
            accLd => accLd,
            inReady => inReady,
            outValid => outValid
        );
    test1(0) <= aluOutFlagE;

    E : ENTITY work.reg(structural)
        GENERIC MAP(width => 1)
        PORT MAP(
            clk => clk,
            rstn => resetn,
            en => flagLd,
            d => test1,
            q => test3
        );

    flagEOut <= test3(0);

    test2(0) <= aluOutFlagZ;
    Z : ENTITY work.reg(structural)
        GENERIC MAP(width => 1)
        PORT MAP(
            clk => clk,
            rstn => resetn,
            en => flagLd,
            -- d(0) => aluOutFlagZ
            d => test2,
            q => test4
        );

    flagZOut <= test4(0);

    PC : ENTITY work.reg(structural)
        GENERIC MAP(width => 8)
        PORT MAP(
            clk => clk,
            rstn => resetn,
            en => pcLd,
            d => nextPC,
            q => pcOut
        );

    ACC : ENTITY work.reg(structural)
        GENERIC MAP(width => 8)
        PORT MAP(
            clk => clk,
            rstn => resetn,
            en => accLd,
            d => accIn,
            q => accOut
        );

    ALU : ENTITY work.alu(structural)
        GENERIC MAP(
            width => 8
        )
        PORT MAP(
            alu_inA => busOut,
            alu_inB => accOut,
            alu_op => aluOp,
            E => aluOutFlagE,
            Z => aluOutFlagZ,
            alu_out => aluOut
        );

    InMEM : ENTITY work.memory(behavioral)
        GENERIC MAP(
            DATA_WIDTH => 12,
            ADDR_WIDTH => 8,
            INIT_FILE => iInitFile
        )
        PORT MAP(
            clk => clk,
            readEn => imRead,
            writeEn => '0',
            address => pcOut,
            dataIn => "000000000000",
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
            dataIn => accOut,
            dataOut => dmDataOut
        );

    INBUS : ENTITY work.proc_bus(behavioral)
        PORT MAP(
            busSel => busSel,
            imDataOut => imDataOutBus,
            dmDataOut => dmDataOut,
            accOut => accOut,
            extIn => extIn,
            busOut => busOut
        );

    pcIncr : ENTITY work.rca(structural)
        GENERIC MAP(width => 8)
        PORT MAP(
            A => pcOut, -- current address
            B => "00000001", -- increment of 1
            cin => '0', -- no cin
            cout => OPEN,
            O => pcIncrOut
        );

    -- Same logic as in the ALU for addition or subtraction
    offset <= '0' & busOut(6 DOWNTO 0);
    -- Create a mask containing either 00000000 or 11111111 depending on the MSB of busOut
    mask <= (OTHERS => busOut(7));
    -- Flip the bits of the offset if we want to subtract, otherwise keep it the same way
    jumpAddrInputB <= offset XOR mask;
    jmpAddr : ENTITY work.rca(structural)
        GENERIC MAP(width => 8)
        PORT MAP(
            A => pcOut,
            B => jumpAddrInputB,
            cin => busOut(7), -- if MSB is 1, we add 1 to get the 2's complement
            cout => OPEN,
            O => jumpAddr
        );

    -- multiplexer for pcSel
    WITH pcSel SELECT nextPC <=
        pcIncrOut WHEN '0',
        jumpAddr WHEN OTHERS;

    -- multiplexer for accSel
    WITH accSel SELECT accIn <=
        aluOut WHEN '0',
        busOut WHEN OTHERS;

    extOut <= accOut;
    pc2seg <= pcOut;
    imdataOut2seg <= imDataOutFull;
    dmDataOut2seg <= dmDataOut;
    aluOut2seg <= aluOut;
    acc2seg <= accOut;
    busOut2seg <= busOut;
END structural;