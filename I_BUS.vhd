---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------
entity I_BUS is
port(
	sel : in std_logic_vector(1 downto 0);			--input from CU BUS_sel
	CU_in : in std_logic_vector(15 downto 0);		--input data from CU
	REG_BANK_in : in std_logic_vector(15 downto 0);		--input data from REG_BANK dat_ob
	RAM_data_in : in std_logic_vector(15 downto 0);		--input data from RAM data_out
	ALU_in : in std_logic_vector(15 downto 0);		--input data from ALU data_out
	BUS_out : out std_logic_vector(15 downto 0));
end entity;
architecture I_BUS_AR of I_BUS is
signal tmp_out  : std_logic_vector(15 downto 0);
begin
with sel select BUS_out <=
	CU_in when "00",
	REG_BANK_in when "01",
	ALU_in when "10",
	RAM_data_in when "11",
	"0000000000000000" when others;
end architecture;

