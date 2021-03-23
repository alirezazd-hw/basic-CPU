---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------

entity RAM is
generic ( N : integer := 16;	-- number of data bits
	  M : integer := 4	-- number of address bits
);
port (
	clk : in std_logic;				-- clock
	adr : in std_logic_vector(M-1 downto 0);	-- address input form AR
	data_in : in std_logic_vector(N-1 downto 0);	-- data input from BUS
	data_out : out std_logic_vector(N-1 downto 0);	-- output data to BUS
	load : in std_logic;				-- load enable input from CU RAM_load
--------------------------------------------------------------------------------------------------------------------
	T_out0 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out1 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out2 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out3 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out4 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out5 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out6 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out7 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out8 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out9 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out10 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out11 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out12 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out13 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out14 : out std_logic_vector(N-1 downto 0);	-- RAM TEST out
	T_out15 : out std_logic_vector(N-1 downto 0)	-- RAM TEST out
--------------------------------------------------------------------------------------------------------------------
);
end entity;

architecture RAM_AR of RAM is
type mem_array is array (0 to 2**M-1) of std_logic_vector(N-1 downto 0);
signal ram : mem_array;	-- memory array
signal tmp  : std_logic_vector(N-1 downto 0) := "0000000000000000"; 
begin
p0:process(clk,load)
begin
if clk='1' then
	if(load='1') then
	ram(conv_integer(adr)) <= data_in;
	end if;
end if;
end process;
p1:process(adr,load)
begin
if(load='0') then
	tmp <= ram(conv_integer(adr)); -- read
end if;
end process;
		T_out0 <= ram(0);
		T_out1 <= ram(1);
		T_out2 <= ram(2);
		T_out3 <= ram(3);
		T_out4 <= ram(4);
		T_out5 <= ram(5);
		T_out6 <= ram(6);
		T_out7 <= ram(7);
		T_out8 <= ram(8);
		T_out9 <= ram(9);
		T_out10 <= ram(10);
		T_out11 <= ram(11);
		T_out12 <= ram(12);
		T_out13 <= ram(13);
		T_out14 <= ram(14);
		T_out15 <= ram(15);
data_out <= tmp;
end architecture;

------------------------Test Bench-----------------------
-- erase T_out0 ~ T_out15 from entity before using test bench to prevent errors


--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.std_logic_unsigned.all;
--use IEEE.std_logic_arith.all;

--entity test_RAM is
--generic ( N : integer := 16;	-- number of data bits
--	  M : integer := 4	-- number of address bits
--);
--end entity;
--architecture behv of test_RAM is
--signal	tb_adr :  std_logic_vector(M-1 downto 0);
--signal 	tb_clk :  std_logic := '0';			-- Clock
--signal	tb_data_in : std_logic_vector(N-1 downto 0);
--signal	tb_data_out :  std_logic_vector(N-1 downto 0);	
--signal	tb_load : std_logic := '0';					
--begin
--TB : entity work.RAM(RAM_AR)
--	generic map(N => N , M => M)
--	port map(adr => tb_adr, clk => tb_clk , data_in => tb_data_in , data_out => tb_data_out, load => tb_load);
--p0 : process
--begin
--wait for 10 ns;
--tb_clk <=  not tb_clk;
--end process;
--p1 : process
--begin
--tb_data_in <= "1111111111111100";
--wait for 5 ns;
--tb_adr <= "1000";
--wait for 5 ns;
--tb_load <= '1';
--wait for 5 ns;
--tb_load <= '0';
--end process;
--end architecture;
			


