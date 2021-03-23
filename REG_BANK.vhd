---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------

-- Register Bank 8 x 16 bits --
entity REG_BANK is
generic (N : integer := 16;				-- number of data bits
	 M : integer := 3				-- number of address bits
);
port (
	clk : in std_logic;				-- clock
	stat : in std_logic;				-- shift & dec/inc sign input from CU REG_BANK_stat
	sh_en : in std_logic;				-- shift enable input from CU REG_BANK_sh_en
	art_en : in std_logic;				-- arithmetic enable input from CU REG_BANK_art_en
	load : in std_logic;				-- load enable input from CU REG_BANK_load
	adr_a : in std_logic_vector(M-1 downto 0);	-- input address (for reg-bank to ALU data output) from IR data_out[0-2]
	adr_b : in std_logic_vector(M-1 downto 0);	-- input address (for reg-bank to BUS data output) from IR data_out[2-5]
	adr_i : in std_logic_vector(M-1 downto 0);	-- input address (for BUS to reg-bank data input) from IR data_out[6-8]
	dat_in : in std_logic_vector(N-1 downto 0); 	-- data input from BUS
	dat_oa : out std_logic_vector(N-1 downto 0); 	-- data output #1 to ALU
	dat_ob : out std_logic_vector(N-1 downto 0)	-- data output #2 to BUS
);
end entity;

architecture REG_BANK_AR of REG_BANK is
type reg_array is array (0 to 2**M-1) of std_logic_vector(N-1 downto 0);
signal reg_bank : reg_array;	-- register bank
begin
P1 : process(clk,load,sh_en,art_en)
begin
	if  clk='1' then
		if(load='1') then
			reg_bank(conv_integer(adr_i)) <= dat_in;		-- load
		elsif(sh_en='1') then
			if(stat = '0') then
				reg_bank(conv_integer(adr_i)) <= reg_bank(conv_integer(adr_i))(N-2 downto 0) & '0';		-- Left Shift
			elsif(stat ='1') then
				reg_bank(conv_integer(adr_i)) <= '0' & reg_bank(conv_integer(adr_i))(N-1 downto 1);		--Right Shift
			end if;
		elsif(art_en ='1') then
			if(stat ='0') then
				reg_bank(conv_integer(adr_i)) <= reg_bank(conv_integer(adr_i))+'1';				--increment
			elsif(stat ='1') then
				reg_bank(conv_integer(adr_i)) <= reg_bank(conv_integer(adr_i))-'1';				--decrement
			end if;
		end if;
	end if;
end process;
dat_oa <= reg_bank(conv_integer(adr_a));
dat_ob <= reg_bank(conv_integer(adr_b));
end architecture;
------------------------Test Bench-----------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity Test_REG_BANK is
generic (N : integer := 16;	-- number of data bits
	 M : integer := 3	-- number of address bits
);
end entity;

architecture behv of Test_REG_BANK is
signal 	tb_clk :  std_logic := '0';			-- Clock
signal	tb_stat :  std_logic := '0';				-- shift & dec/inc sign
signal	tb_sh_en :  std_logic := '0';				-- shift enable
signal	tb_art_en :  std_logic := '0';				-- arithmetic enable
signal	tb_load  :  std_logic := '0';				-- load enable
signal	tb_adr_a :  std_logic_vector(M-1 downto 0);	-- input address for reg-bank to ALU data output
signal	tb_adr_b :  std_logic_vector(M-1 downto 0);	-- input address for reg-bank to BUS data output
signal	tb_adr_i :  std_logic_vector(M-1 downto 0);	-- input address for BUS to reg-bank data input
signal	tb_dat_in :  std_logic_vector(N-1 downto 0); 	-- data input from BUS
signal	tb_dat_oa : std_logic_vector(N-1 downto 0); 	-- data output #1 to ALU
signal	tb_dat_ob :  std_logic_vector(N-1 downto 0);	-- data output #2 to BUS
begin
TB : entity work.REG_BANK(REG_BANK_AR)
	generic map(N => N , M => M)
	port map(clk => tb_clk , stat => tb_stat , sh_en => tb_sh_en , art_en => tb_art_en , load => tb_load , adr_a => tb_adr_a , adr_b => tb_adr_b , adr_i => tb_adr_i , dat_in => tb_dat_in ,dat_oa => tb_dat_oa , dat_ob => tb_dat_ob);
p1 : process
begin
wait for 50 ns;
tb_clk <=  not tb_clk;
end process;
p2 : process
begin
wait until rising_edge(tb_clk);
tb_load <= '1';
--for i in 0 to 2**M-1 loop
tb_dat_in <= "1111111111111000";
tb_adr_i <= conv_std_logic_vector(6,M);
--wait until rising_edge(tb_clk);
wait for 5 ns;
tb_load <= '0';
--end loop;
--tb_load <= '0';
tb_sh_en <= '1';
tb_stat <= '1';
--for i in 0 to 2**M-1 loop
wait for 5 ns;
tb_sh_en <= '0';
--tb_adr_i <= conv_std_logic_vector(i,M);
--end loop;
--for i in 0 to 2**M-1 loop
--wait until rising_edge(tb_clk);
tb_adr_a <= conv_std_logic_vector(6,M);
--end loop;
end process;
end architecture;