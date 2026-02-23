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

type state_type is (FE, DE1, DE2, EX, ME);
signal curr_state : state_type;
signal next_state : state_type;

BEGIN


--storage section
process (clk, resetn)
begin
	if resetn = '0' then 
	 curr_state <= FE;
	 elsif rising_edge(clk) then
	 if master_load_enable = '1' then
	  curr_state <= next_state;
	 end if;
	end if;
      

end process;

--combunational part
process (curr_state, next_state)
begin

--default values to avoid setting stuff to 0 all the time
next_state <= curr_state;
busSel   <= (others => '0');
pcSel    <= '0';
pcLd     <= '0';
imRead   <= '0';
dmRead   <= '0';
dmWrite  <= '0';
aluOp    <= (others => '0');
flagLd   <= '0';
accSel   <= '0';
accLd    <= '0';
inReady  <= '0';
outValid <= '0';

case curr_state is

When FE=>
 pcSEL <= '0';
 pcLd <= '1';
 imread <= '1';
 next_state <= DE1;

when DE1=>
dmRead <= '1';
busSel <= B_IMEM;
case opcode is

when O_NOOP =>
next_state <= FE;

when O_SBI | O_SB =>
next_state <= ME;

when O_LBI =>
next_state <= DE2;

when O_JE =>
 if e_flag = '1' then 
 next_state <= EX;
 else 
 next_state <= FE;
 end if;

when O_JNZ=>
 if z_flag = '0' then
 next_state <= EX;
 else 
 next_state <= FE;
 end if;

when others =>
next_state <= EX;
end case;

when DE2=>
busSel <=  B_DMEM;
dmRead <= '1';
next_state <= EX;

when EX=>

if opcode = O_IN then
 if inValid = '1' then
  busSel <= B_EXT;
  accLd <= '1';
  accSel <= '1'; 
  next_state <= FE;
 end if;
end if;

if opcode = O_OUT then
 if outReady = '1' then
  outValid <= '1';
  next_state <= FE;
 end if;
end if;

if opcode = O_MOV then 
  busSel <= B_IMEM;
  accSel <= '1';
  accLd <= '1';
  next_state <= FE;
end if;

if opcode = O_J then
  busSel <= B_ACC;
  pcSel <= '1';
  pcLd <= '1';
  next_state <= FE;
end if;

if opcode = O_JE or opcode = O_JNZ then
  busSel <= B_IMEM;
  pcSel <= '1';
  pcLd <= '1';
  next_state <= FE;
end if;

if opcode = O_CMP then
  busSel <= B_DMEM;
  flagLd <= '1';
  next_state <= FE;
end if;

if opcode = O_XOR then
   busSel <= B_DMEM;
   flagLd <= '1';
   aluOp <= A_XOR; 
   accSel <= '0';
   accLd <= '1';
   next_state <= FE;
end if;

if opcode = O_AND then
   busSel <= B_DMEM;
   flagLd <= '1';
   aluOp <= A_AND; 
   accSel <= '0';
   accLd <= '1';
   next_state <= FE;
end if;

if opcode = O_ADD then
   busSel <= B_DMEM;
   flagLd <= '1';
   aluOp <= A_ADD; 
   accSel <= '0';
   accLd <= '1';
   next_state <= FE;
end if;

if opcode = O_SUB then 
   busSel <= B_DMEM;
   flagLd <= '1';
   aluOp <= A_SUB; 
   accSel <= '0';
   accLd <= '1';
   next_state <= FE;
end if;

if opcode = O_LB then
   busSel <= B_DMEM;
   accSel <= '1';
   accLd <= '1';
   next_state <= FE;
end if;

if opcode = O_LBI then
   busSel <= B_DMEM;
   accSel <= '1';
   accLd <= '1';
   next_state <= FE;
end if;

when ME=>

if opcode = O_SB then
  dmWrite <= '1';
  next_state <= FE;
end if;

if opcode = O_SBI then
  busSel <= B_DMEM;
  dmWrite <= '1';
  next_state <= FE;
end if;
end case; 
end process;
  
END test;