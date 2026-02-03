library ieee;
use ieee.std_logic_1164.all;

entity tb_csa is
end;

architecture sim of tb_csa is
    signal A, B : std_logic_vector(7 downto 0);
    signal cin  : std_logic;
    signal cout : std_logic;
    signal O    : std_logic_vector(7 downto 0);
begin

    dut: entity work.csa(structural)
        port map (
            A => A,
            B => B,
            cin => cin,
            cout => cout,
            O => O
        );

    process
    begin
        -- Case 1: 0 + 0
        A <= "00000000"; B <= "00000000"; cin <= '0';
        wait for 10 ns;

        -- Case 2: 15 + 1 = 16 (carry from low nibble selects hi+1 path)
        A <= "00001111"; B <= "00000001"; cin <= '0';
        wait for 10 ns;

        -- Case 3: 255 + 1 = 0 with cout=1
        A <= "11111111"; B <= "00000001"; cin <= '0';
        wait for 10 ns;

        wait;
    end process;

end sim;

