---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------

entity ALU is
port(	en : in std_logic;					--input from CU ALU_en
	fx : in std_logic_vector(1 downto 0);			--input from CU ALU_fx
	data_out : out std_logic_vector(15 downto 0);		--output data to BUS
	data_in_a : in std_logic_vector(15 downto 0);		--input data from REG_BANK dat_oa
	data_in_b : in std_logic_vector(15 downto 0));		--input data from BUS
end entity;

Architecture ALU_AR of ALU is
signal tmp_out  : std_logic_vector(15 downto 0);
begin
process(en)
begin
	if(en = '1') then
		case fx is
			when "00" => tmp_out <= data_in_a AND data_in_b;		-- AND
			when "01" => tmp_out <= data_in_a + data_in_b;			-- ADD
			when "10" => tmp_out <= data_in_a - data_in_b;			-- SUB
			when others => tmp_out <= "0000000000000000";	
		end case;
	end if;
end process;
data_out <= tmp_out;
end Architecture;

------------------------Test Bench-----------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity Test_ALU is
end entity;

architecture behv of Test_ALU is
	signal  tb_en : std_logic;
	signal	tb_fx : std_logic_vector(1 downto 0);
	signal	tb_data_out : std_logic_vector(15 downto 0);
	signal	tb_data_in_a : std_logic_vector(15 downto 0);
	signal	tb_data_in_b : std_logic_vector(15 downto 0);
begin
TB : entity work.ALU(ALU_AR)
	port map(en => tb_en , fx => tb_fx , data_out => tb_data_out , data_in_a => tb_data_in_a , data_in_b => tb_data_in_b);
tb_fx <= "00", "01" after 10 ns , "10" after 20 ns;
tb_data_in_a <= "0000111111111111";
tb_data_in_b <= "0000000011111111";
tb_en <= '0','1' after 5 ns,'0' after 10 ns,'1' after 15 ns,'0' after 20 ns,'1' after 25 ns,'0' after 30 ns;
end architecture;