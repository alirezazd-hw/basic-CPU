---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------

entity AR is
generic (M: integer := 4);
port(   load : in std_logic;					--input from CU AR_load
	clk : in std_logic;					--clock
	adr_out : out std_logic_vector(M-1 downto 0);		--output to RAM adr
	adr_in : in std_logic_vector(M-1 downto 0));		--input from IR data_out[8-11]
end entity;

Architecture AR_AR of AR is
signal tmp  : std_logic_vector(3 downto 0) := "0000"; 
begin
process(clk,load)
begin
	if clk='1' then
		if(load = '1') then
			tmp <= adr_in;
		end if;
	end if;
end process;
adr_out <= tmp;
end Architecture;
			