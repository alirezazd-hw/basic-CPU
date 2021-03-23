---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------


entity CU is
generic ( N : integer := 16;	-- number of data bits
	  M : integer := 4	-- number of address bits
);
port (
	clk : in std_logic;				-- Clock
	IR_IN : in std_logic_vector(N-1 downto 0);	-- IR input			
	IR_load : out std_logic := '0';			-- IR load
	PC_inc : out std_logic := '0';			-- PC increment
	AR_load : out std_logic := '0';			-- AR load
	RAM_load : out std_logic := '0';		-- RAM load
	REG_BANK_stat : out std_logic := '0';		-- REG BANK state
	REG_BANK_sh_en : out std_logic := '0';		-- REG BANK shift enable
	REG_BANK_art_en : out std_logic := '0';		-- REG BANK increment/decrement enable
	REG_BANK_load : out std_logic := '0';		-- REG BANK load
	BUS_sel : out std_logic_vector(1 downto 0);	-- BUS selection
	ALU_en : out std_logic := '0';			-- ALU enable
	ALU_fx : out std_logic_vector(1 downto 0);	-- ALU operation
	data_out : out std_logic_vector(N-1 downto 0));	-- CU data out to BUS for extended bit
	
end entity;

architecture CU_AR of CU is
begin
process(clk)
begin
if(rising_edge(clk)) then
IR_load <= '1','0' after 5 ns; 					-- load new instruction 
end if;
end process;
process(IR_IN) 							 -- decode and execute when IR changes 
begin
--------------------------------------------------------
if (clk ='1') then
	if IR_IN(15 downto 12) = "0000" then			-- ADD
		BUS_sel <= "01","10" after 14 ns;
		ALU_fx <=  "01";
		ALU_en <= '0','1' after 10 ns,'0' after 15 ns;
		REG_BANK_load <= '0','1' after 15 ns,'0' after 20 ns;
		PC_inc <= '0','1' after 20 ns,'0' after 25 ns;
	end if;
	if IR_IN(15 downto 12) = "0001" then			-- AND
		BUS_sel <= "01","10" after 14 ns;
		ALU_fx <=  "00";
		ALU_en <= '0','1' after 10 ns,'0' after 15 ns;
		REG_BANK_load <= '0','1' after 15 ns,'0' after 20 ns;
		PC_inc <= '0' ,'1' after 20 ns,'0' after 25 ns;
	end if;
	if IR_IN(15 downto 12) = "0010" then			-- SUB
		BUS_sel <= "01","10" after 14 ns;
		ALU_fx <=  "10";
		ALU_en <= '0','1' after 10 ns,'0' after 15 ns;
		REG_BANK_load <= '0','1' after 15 ns,'0' after 20 ns;
		PC_inc <= '0' ,'1' after 20 ns,'0' after 25 ns;
	end if;
	if IR_IN(15 downto 12) = "0011" then			-- SHL
		REG_BANK_stat <= '0';
		REG_BANK_sh_en <= '0','1' after 10 ns,'0' after 15 ns;
		PC_inc <= '0' ,'1' after 15 ns,'0' after 20 ns;
	end if;
	if IR_IN(15 downto 12) = "0100" then			-- SHR
		REG_BANK_stat <= '1';
		REG_BANK_sh_en <= '0','1' after 10 ns,'0' after 15 ns;
		PC_inc <= '0' ,'1' after 15 ns,'0' after 20 ns;
	end if;
	if IR_IN(15 downto 12) = "0101" then			-- INC
		REG_BANK_stat <= '0';
		REG_BANK_art_en <= '0','1' after 10 ns,'0' after 15 ns;
		PC_inc <= '0' ,'1' after 15 ns,'0' after 20 ns;
	end if;
	if IR_IN(15 downto 12) = "0110" then			-- DEC
		REG_BANK_stat <= '1';
		REG_BANK_art_en <= '0','1' after 10 ns,'0' after 15 ns;
		PC_inc <= '0' ,'1' after 15 ns,'0' after 20 ns;
	end if;
	if (IR_IN(15 downto 12) = "0111") then			-- MOV
		data_out <= IR_IN(11)&IR_IN(11)&IR_IN(11)&IR_IN(11)&IR_IN(1)&IR_IN(11)&IR_IN(11)&IR_IN(11 downto 3);
		BUS_sel <= "00";
		REG_BANK_load <= '0','1' after 10 ns ,'0' after 15 ns;
		PC_inc <= '0' ,'1' after 15 ns,'0' after 20 ns;
	end if;
	if (IR_IN(15 downto 12) = "1000") then			-- LOD
		AR_load <= '0','1' after 10 ns ,'0' after 15 ns;
		BUS_sel <= "11";
		REG_BANK_load <= '0' ,'1' after 15 ns,'0' after 20 ns;
		PC_inc <= '0','1' after 20 ns,'0' after 25 ns;
	end if;	
	if (IR_IN(15 downto 12) = "1001") then			-- SVE
		AR_load <= '0','1' after 10 ns ,'0' after 15 ns;
		BUS_sel <= "01";
		RAM_load <= '0' ,'1' after 15 ns,'0' after 20 ns;
		PC_inc <= '0','1' after 20 ns,'0' after 25 ns;
	end if;
	if (IR_IN(15 downto 12) = "1111") then			-- NOP (no operation)
	end if;								
end if;
end process;
end architecture;
------------------------Test Bench-----------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity test_CU is
generic ( N : integer := 16;	-- number of data bits
	  M : integer := 4	-- number of address bits
);
end entity;
architecture behv of test_CU is
type mem_array is array (0 to 2**M-1) of std_logic_vector(N-1 downto 0);
constant ROM:mem_array:= (
          X"0000",X"1000",X"2000",X"3000",
          X"4000",X"5000",X"6000",X"7000",
          X"8000",X"9000",X"FFFF",X"FFFF",
          X"FFFF",X"FFFF",X"F000",X"FFFF");
signal	tb_clk : std_logic := '0';				-- Clock
signal	tb_IR_IN :	std_logic_vector(N-1 downto 0);			
signal	tb_IR_load : std_logic;
signal	tb_PC_inc : std_logic;
signal	tb_AR_load : std_logic;
signal	tb_RAM_load : std_logic;
signal	tb_REG_BANK_stat : std_logic;
signal	tb_REG_BANK_sh_en : std_logic;
signal	tb_REG_BANK_art_en : std_logic;
signal	tb_REG_BANK_load : std_logic;
signal	tb_BUS_sel : std_logic_vector(1 downto 0);
signal	tb_ALU_en : std_logic;
signal	tb_ALU_fx : std_logic_vector(1 downto 0);
signal	tb_data_out :  std_logic_vector(N-1 downto 0);
begin	
TB : entity work.CU(CU_AR)
	generic map(M => M)
	port map( clk => tb_clk , IR_IN => tb_IR_IN , IR_load => tb_IR_load , PC_inc => tb_PC_inc ,
		 AR_load => tb_AR_load , RAM_load => tb_RAM_load , REG_BANK_stat => tb_REG_BANK_stat , REG_BANK_sh_en => tb_REG_BANK_sh_en
		,REG_BANK_art_en => tb_REG_BANK_art_en, REG_BANK_load => tb_REG_BANK_load , BUS_sel => tb_BUS_sel , ALU_en => tb_ALU_en ,
		ALU_fx => tb_ALU_fx , data_out => tb_data_out);
p0 : process
begin
wait for 50 ns;
tb_clk <=  not tb_clk;
end process;
p1: process(tb_clk)
variable tmp : integer :=0;	
begin
	if tb_clk ='1' then
		tb_IR_IN<= ROM(tmp);
		tmp:=tmp+1;
	end if;
end process;
end architecture;
			