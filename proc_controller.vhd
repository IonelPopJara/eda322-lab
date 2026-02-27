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

    TYPE state_type IS (FE, DE1, DE2, EX, ME);
    SIGNAL curr_state : state_type;
    SIGNAL next_state : state_type;

BEGIN
    --storage section
    PROCESS (clk, resetn)
    BEGIN
        IF resetn = '0' THEN
            curr_state <= FE;
        ELSIF rising_edge(clk) THEN
            IF master_load_enable = '1' THEN
                curr_state <= next_state;
            END IF;
        END IF;
    END PROCESS;

    --combinational part
    PROCESS (curr_state, opcode, e_flag, z_flag, inValid, outReady, resetn, master_load_enable)
    BEGIN

        --default values to avoid setting stuff to 0 all the time
        next_state <= curr_state;
        busSel <= (OTHERS => '0');
        pcSel <= '0';
        pcLd <= '0';
        imRead <= '0';
        dmRead <= '0';
        dmWrite <= '0';
        aluOp <= (OTHERS => '0');
        flagLd <= '0';
        accSel <= '0';
        accLd <= '0';
        inReady <= '0';
        outValid <= '0';

        CASE curr_state IS

            WHEN FE =>
                pcSEL <= '0';
                pcLd <= '1';
                imRead <= '1';
                next_state <= DE1;

            WHEN DE1 =>
                -- 1. Next State Routing
                CASE opcode IS
                    WHEN O_NOOP =>
                        next_state <= FE;
                    WHEN O_SBI | O_SB =>
                        next_state <= ME;
                    WHEN O_LBI =>
                        next_state <= DE2;
                    WHEN OTHERS =>
                        next_state <= EX;
                END CASE;

                IF opcode = O_CMP OR opcode = O_XOR OR opcode = O_AND OR
                    opcode = O_ADD OR opcode = O_SUB OR opcode = O_LB OR
                    opcode = O_LBI OR opcode = O_SBI THEN

                    busSel <= B_IMEM;
                    dmRead <= '1';
                END IF;

            WHEN DE2 =>
                busSel <= B_DMEM;
                dmRead <= '1';
                next_state <= EX;

            WHEN EX =>
                next_state <= FE;

                IF opcode = O_IN THEN
                    busSel <= B_EXT;
                    accSel <= '1';
                    inReady <= '1';
                    IF inValid = '1' THEN
                        accLd <= '1';
                        next_state <= FE;
                    ELSE
                        next_state <= curr_state;
                    END IF;
                END IF;

                IF opcode = O_OUT THEN
                    outValid <= '1';
                    IF outReady = '1' THEN
                        next_state <= FE;
                    ELSE
                        next_state <= curr_state;
                    END IF;
                END IF;

                IF opcode = O_MOV THEN
                    busSel <= B_IMEM;
                    accSel <= '1';
                    accLd <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_J THEN
                    busSel <= B_ACC;
                    pcSel <= '1';
                    pcLd <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_JE THEN
                    busSel <= B_IMEM;
                    pcSel <= '1';
                    IF e_flag = '1' THEN
                        pcLd <= '1';
                    END IF;
                    next_state <= FE;
                END IF;

                IF opcode = O_JNZ THEN
                    busSel <= B_IMEM;
                    pcSel <= '1';
                    IF z_flag = '0' THEN
                        pcLd <= '1';
                    END IF;
                    next_state <= FE;
                END IF;

                IF opcode = O_CMP THEN
                    busSel <= B_DMEM;
                    flagLd <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_XOR THEN
                    busSel <= B_DMEM;
                    flagLd <= '1';
                    aluOp <= A_XOR;
                    accSel <= '0';
                    accLd <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_AND THEN
                    busSel <= B_DMEM;
                    flagLd <= '1';
                    aluOp <= A_AND;
                    accSel <= '0';
                    accLd <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_ADD THEN
                    busSel <= B_DMEM;
                    flagLd <= '1';
                    aluOp <= A_ADD;
                    accSel <= '0';
                    accLd <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_SUB THEN
                    busSel <= B_DMEM;
                    flagLd <= '1';
                    aluOp <= A_SUB;
                    accSel <= '0';
                    accLd <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_LB THEN
                    busSel <= B_DMEM;
                    accSel <= '1';
                    accLd <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_LBI THEN
                    busSel <= B_DMEM;
                    accSel <= '1';
                    accLd <= '1';
                    next_state <= FE;
                END IF;

            WHEN ME =>
                next_state <= FE;

                IF opcode = O_SB THEN
                    busSel <= B_IMEM;
                    dmWrite <= '1';
                    next_state <= FE;
                END IF;

                IF opcode = O_SBI THEN
                    busSel <= B_DMEM;
                    dmWrite <= '1';
                    next_state <= FE;
                END IF;
        END CASE;

        -- 1. Override outputs and state if master_load_enable is 0
        IF master_load_enable = '0' THEN
            next_state <= curr_state;
            imRead <= '0';
            dmRead <= '0';
            dmWrite <= '0';
            pcLd <= '0';
            flagLd <= '0';
            accLd <= '0';
            inReady <= '0';
            outValid <= '0';
        END IF;

    END PROCESS;

END test;