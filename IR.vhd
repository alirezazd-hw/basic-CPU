---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------

entity IR is
generic (M: integer :=16);
port(   load : in std_logic;					--input from CU IR_load
	clk : in std_logic;					--clock
	data_in : in std_logic_vector(M-1 downto 0);		--input form ROM
	data_out : out std_logic_vector(M-1 downto 0));		--output to CU IR_IN

end entity;

Architecture IR_AR of IR is
signal tmp  : std_logic_vector(M-1 downto 0);
begin
process(clk,load)
begin
	if clk='1' then
		if(load = '1') then
			tmp <= data_in;
		end if;
	end if;
end process;
data_out <= tmp;
end Architecture;

------------------------Test Bench-----------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity test_IR is
generic (M: integer :=16);
end entity;
architecture behv of test_IR is
signal	tb_load : std_logic := '0';
signal 	tb_clk :  std_logic := '0';			-- Clock
signal	tb_data_in : std_logic_vector(M-1 downto 0);
signal	tb_data_out :  std_logic_vector(M-1 downto 0);						
begin
TB : entity work.IR(IR_AR)
	generic map(M => M)
	port map(load => tb_load , clk => tb_clk , data_in => tb_data_in , data_out => tb_data_out);
p0 : process
begin
wait for 50 ns;
tb_clk <=  not tb_clk;
end process;
p1 : process(tb_clk)
begin
if (tb_clk ='1') then
	tb_data_in <= "0000110101011111";
	tb_load <= '1','0' after 5 ns;
end if;
end process;
end architecture;
			

