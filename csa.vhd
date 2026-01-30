LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;

ENTITY csa IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        cin : IN STD_LOGIC;
        cout : OUT STD_LOGIC;
        O : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END csa;

ARCHITECTURE structural OF csa IS
    SIGNAL l_cout : STD_LOGIC;
    SIGNAL z_cout : STD_LOGIC;
    SIGNAL o_cout : STD_LOGIC;
    SIGNAL l_O : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL z_O : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL o_O : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL f_O : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
    LRCA : ENTITY work.rca(structural)
        GENERIC MAP(width => 4)
        PORT MAP(
            A => A(3 DOWNTO 0), -- first 4 bits of A
            B => B(3 DOWNTO 0), -- first 4 bits of B
            cin => cin, -- actual carry in of the csa
            cout => l_cout,
            O => l_O
        );

    ZRCA : ENTITY work.rca(structural) -- carry in 0 (Zero)
        GENERIC MAP(width => 4)
        PORT MAP(
            A => A(7 DOWNTO 4),
            B => B(7 DOWNTO 4),
            cin => '0',
            cout => z_cout,
            O => z_O
        );

    ORCA : ENTITY work.rca(structural) -- carry in 1 (One)
        GENERIC MAP(width => 4)
        PORT MAP(
            A => A(7 DOWNTO 4),
            B => B(7 DOWNTO 4),
            cin => '1',
            cout => o_cout,
            O => o_O
        );

    f_O <= o_O WHEN l_cout = '1' ELSE
        z_O;

    cout <= o_cout WHEN l_cout = '1' ELSE
        z_cout;

    O <= f_O & l_O;
END structural;