LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE ieee.std_logic_misc.ALL;

ENTITY testbench_lab4 IS
END testbench_lab4;

ARCHITECTURE tb OF testbench_lab4 IS
    CONSTANT D_MEM_FILE : STRING := "d_memory_lab4.mif";
    CONSTANT I_MEM_FILE : STRING := "i_memory_lab4.mif";

    -- COMPONENT EDA322_processor IS
    --     PORT (
    --         clk : IN STD_LOGIC;
    --         resetn : IN STD_LOGIC;
    --         master_load_enable : IN STD_LOGIC;
    --         extIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         inValid : IN STD_LOGIC;
    --         outReady : IN STD_LOGIC;
    --         pc2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         imDataOut2seg : STD_LOGIC_VECTOR(11 DOWNTO 0);
    --         dmDataOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         aluOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         acc2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         busOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         extOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         inReady : STD_LOGIC;
    --         outValid : STD_LOGIC
    --     );
    -- END COMPONENT;

    -- COMPONENT reference_processor IS
    --     PORT (
    --         clk : IN STD_LOGIC;
    --         resetn : IN STD_LOGIC;
    --         master_load_enable : IN STD_LOGIC;
    --         extIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         inValid : IN STD_LOGIC;
    --         outReady : IN STD_LOGIC;
    --         pc2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         imDataOut2seg : STD_LOGIC_VECTOR(11 DOWNTO 0);
    --         dmDataOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         aluOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         acc2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         busOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         extOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --         inReady : STD_LOGIC;
    --         outValid : STD_LOGIC
    --     );
    -- END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL resetn : STD_LOGIC := '0';
    SIGNAL master_load_enable : STD_LOGIC := '0';
    SIGNAL inValid, outReady : STD_LOGIC := '0';
    SIGNAL extIn : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- output signals
    SIGNAL inReady, RinReady : STD_LOGIC;
    SIGNAL outValid, ROutValid : STD_LOGIC;
    SIGNAL extOut, RextOut : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- segment display signals eda322
    SIGNAL pc2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL imDataOut2seg : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL dmDataOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL aluOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL acc2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL busOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- segment display signals reference processor
    SIGNAL Rpc2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL RimDataOut2seg : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL RdmDataOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL RaluOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Racc2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL RbusOut2seg : STD_LOGIC_VECTOR(7 DOWNTO 0);

    CONSTANT CLK_PERIOD : TIME := 10 ns;

BEGIN
    ref_proc : ENTITY work.reference_processor
        GENERIC MAP(
            dInitFile => D_MEM_FILE,
            iInitFile => I_MEM_FILE
        )
        PORT MAP(
            clk => clk,
            resetn => resetn,
            master_load_enable => master_load_enable,
            extIn => extIn,
            inValid => inValid,
            outReady => outReady,
            pc2seg => Rpc2seg,
            imDataOut2seg => RimDataOut2Seg,
            dmDataOut2seg => RdmDataOut2seg,
            aluOut2seg => RaluOut2seg,
            acc2seg => Racc2seg,
            busOut2seg => RbusOut2seg,
            extOut => RextOut,
            inReady => RinReady,
            outValid => RoutValid
        );

    eda322_proc : ENTITY work.EDA322_processor
        GENERIC MAP(
            dInitFile => D_MEM_FILE,
            iInitFile => I_MEM_FILE
        )
        PORT MAP(
            clk => clk,
            resetn => resetn,
            master_load_enable => master_load_enable,
            extIn => extIn,
            inValid => inValid,
            outReady => outReady,
            pc2seg => pc2seg,
            imDataOut2seg => imDataOut2Seg,
            dmDataOut2seg => dmDataOut2seg,
            aluOut2seg => aluOut2seg,
            acc2seg => acc2seg,
            busOut2seg => busOut2seg,
            extOut => extOut,
            inReady => inReady,
            outValid => outValid
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

    Logic_get : PROCESS
    BEGIN
        resetn <= '0';
        WAIT FOR CLK_PERIOD;
        resetn <= '1';
        WAIT FOR CLK_PERIOD;
    END PROCESS;

END ARCHITECTURE tb;