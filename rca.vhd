LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;

ENTITY rca IS
    GENERIC (width : INTEGER := 4);
    PORT (
        A, B : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        cin : IN STD_LOGIC;
        cout : OUT STD_LOGIC;
        O : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
    );
END rca;

ARCHITECTURE structural OF rca IS
    SIGNAL tmp_cout : STD_LOGIC_VECTOR(width DOWNTO 0);
BEGIN

    tmp_cout(0) <= cin;

    AD : FOR i IN 0 TO width - 1 GENERATE
    BEGIN
        T : ENTITY work.fa(dataflow)
            PORT MAP(
                a => A(i),
                b => B(i),
                cin => tmp_cout(i),
                cout => tmp_cout(i + 1),
                s => O(i)
            );
    END GENERATE AD;

    cout <= tmp_cout(width);
END structural;