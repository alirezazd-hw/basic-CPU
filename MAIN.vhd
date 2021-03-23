---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------
entity MAIN is
port(	test0 : out std_logic_vector(15 downto 0); -- RAM OUT
	test1 : out std_logic_vector(15 downto 0); -- RAM OUT
	test2 : out std_logic_vector(15 downto 0); -- RAM OUT
	test3 : out std_logic_vector(15 downto 0); -- RAM OUT
	test4 : out std_logic_vector(15 downto 0); -- RAM OUT
	test5 : out std_logic_vector(15 downto 0); -- RAM OUT
	test6 : out std_logic_vector(15 downto 0); -- RAM OUT
	test7 : out std_logic_vector(15 downto 0); -- RAM OUT
	test8 : out std_logic_vector(15 downto 0); -- RAM OUT
	test9 : out std_logic_vector(15 downto 0); -- RAM OUT
	test10 : out std_logic_vector(15 downto 0); -- RAM OUT
	test11 : out std_logic_vector(15 downto 0); -- RAM OUT
	test12 : out std_logic_vector(15 downto 0); -- RAM OUT
	test13 : out std_logic_vector(15 downto 0); -- RAM OUT
	test14 : out std_logic_vector(15 downto 0); -- RAM OUT
	test15 : out std_logic_vector(15 downto 0) -- RAM OUT
);
end entity;

architecture MAIN_AR of MAIN is
signal s1 : std_logic :='0';				-- clock
signal s2 : std_logic;					-- AR_load <= CU
signal s3 : std_logic_vector(3 downto 0);		-- AR_adr_out => RAM_adr_in 
signal s5 : std_logic;					-- PC_inc <= CU
signal s6 : std_logic_vector(3 downto 0);		-- PC_data_out => ROM_adr
signal s7 : std_logic;					-- IR_load <= CU
signal s8 : std_logic_vector(15 downto 0);		-- IR_data_in <= ROM_dat_out
signal s9 : std_logic_vector(15 downto 0);		-- IR_data_out => CU
signal s11 : std_logic_vector(15 downto 0);		-- RAM_data_in , ALU_data_in_b , REG_BANK_dat_in <= I_BUS
signal s12 : std_logic_vector(15 downto 0);		-- RAM_data_out => I_BUS
signal s13 : std_logic;					-- RAM_load <= CU
signal s14 : std_logic;					-- ALU_en <= CU
signal s15 : std_logic_vector(1 downto 0);		-- ALU_fx <= CU
signal s16 : std_logic_vector(15 downto 0);		-- ALU_data_out => I_BUS
signal s17 : std_logic_vector(15 downto 0);		-- ALU_data_in_a <= REG_BANK
signal s19 : std_logic_vector(1 downto 0);		-- I_BUS_sel <= CU
signal s20 : std_logic_vector(15 downto 0);		-- I_BUS <= CU_data_out
signal s21 : std_logic_vector(15 downto 0);		-- I_BUS <= REG_BANK
signal s22 : std_logic;					-- REG_BANK_stat <= CU
signal s23 : std_logic;					-- REG_BANK_sh_en <= CU
signal s24 : std_logic;					-- REG_BANK_art_en <= CU
signal s25 : std_logic;					-- REG_BANK_load <= CU
begin
p0 : process
begin
wait for 50 ns;
s1 <=  not s1;
end process;
PM1 : entity work.AR(AR_AR) port map(s2,s1,s3,s9(11 downto 8));
PM2 : entity work.PC(PC_AR) port map(s5,s1,s6);
PM3 : entity work.IR(IR_AR) port map(s7,s1,s8,s9);
PM4 : entity work.RAM(RAM_AR) port map(s1,s3,s11,s12,s13,test0,test1,test2,test3,test4,test5,test6,test7,test8,test9,test10,test11,test12,test13,test14,test15);
PM5 : entity work.ROM(ROM_AR) port map(s6,s8);
PM6 : entity work.ALU(ALU_AR) port map(s14,s15,s16,s17,s11);
PM7 : entity work.I_BUS(I_BUS_AR) port map(s19,s20,s21,s12,s16,s11);
PM8 : entity work.REG_BANK(REG_BANK_AR) port map(s1,s22,s23,s24,s25,s9(8 downto 6),s9(5 downto 3),s9(2 downto 0),s11,s17,s21);
PM0 : entity work.CU(CU_AR) port map(s1,s9,s7,s5,s2,s13,s22,s23,s24,s25,s19,s14,s15,s20);
end architecture;

			