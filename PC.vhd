---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------

entity PC is
generic (M: integer := 4);
port(   inc : in std_logic;						--increment input from CU PC_inc
	clk : in std_logic;						--clock
	data_out : out std_logic_vector(M-1 downto 0)); 		--output to ROM adr
end entity;

Architecture PC_AR of PC is
signal tmp  : std_logic_vector(M-1 downto 0) := "0000"; 
begin
process(clk,inc)
begin
	if clk='1' then
		if(inc = '1') then
			tmp <= tmp + 1;					 --increment
		end if;
	end if;
end process;
data_out <= tmp;
end architecture;
------------------------Test Bench-----------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity test_PC is
generic (M: integer :=4);
end entity;
architecture behv of test_PC is
signal	tb_inc : std_logic := '0';
signal 	tb_clk :  std_logic := '0';			-- Clock
signal	tb_data_out :  std_logic_vector(M-1 downto 0);						
begin
TB : entity work.PC(PC_AR)
	generic map(M => M)
	port map(inc => tb_inc , clk => tb_clk , data_out => tb_data_out);
p1 : process
begin
wait for 50 ns;
tb_clk <=  not tb_clk;
end process;
p2 : process
begin
wait for 5 ns;
tb_inc <= '1';
wait for 5 ns;
tb_inc <= '0';
end process;
end architecture;
			

			
