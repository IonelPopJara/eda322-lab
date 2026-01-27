library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity rca is
    generic (width: integer := 4);
    port(
        A, B: in std_logic_vector(width-1 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        O: out std_logic_vector(width-1 downto 0)
    );
end rca;

architecture structural of rca is
signal tmp_cout : std_logic_vector(width-1 downto 0);
begin

tmp_cout(0) <= cin;

AD : for i in 0 to width-1 generate
begin
T: entity work.fa(dataflow) Port map(a => A(i), b => B(i), cin => tmp_cout(i), cout => tmp_cout(i + 1), s => O(i));
end generate AD;

cout <= tmp_cout(width);
end structural;