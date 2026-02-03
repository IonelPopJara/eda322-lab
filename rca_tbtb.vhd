library ieee;
use ieee.std_logic_1164.all;

entity tb_rca is
end;

architecture sim of tb_rca is
    signal A, B : std_logic_vector(3 downto 0);
    signal cin  : std_logic;
    signal cout : std_logic;
    signal O    : std_logic_vector(3 downto 0);
begin

    dut: entity work.rca
        generic map (width => 4)
        port map (
            A => A,
            B => B,
            cin => cin,
            cout => cout,
            O => O
        );

    process
    begin
        -- 0 + 0
        A <= "0000"; B <= "0000"; cin <= '0';
        wait for 10 ns;

        -- 3 + 5 = 8
        A <= "0011"; B <= "0101"; cin <= '0';
        wait for 10 ns;

        -- 15 + 1 = 16 (carry out)
        A <= "1111"; B <= "0001"; cin <= '0';
        wait for 10 ns;

        wait;  -- stop simulation
    end process;

end sim;

