---------------Lib imports-----------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------


entity ROM is
generic ( N: integer:=16;			--number of data bits 
          M: integer:=4   			-- number of address bits
);
port ( adr: in std_logic_vector(M-1 downto 0);			--address input from PC
       dat_out: out std_logic_vector(N-1 downto 0)		--output data to IR data_in
);
end rom;

architecture ROM_AR of ROM is
type mem_array is array (0 to 2**M-1) of std_logic_vector(N-1 downto 0);
constant ROM:mem_array:= ( 					--rom data
          X"7018",X"7029",X"0042",X"9F10",
          X"1042",X"9E10",X"2042",X"9D10",
          X"3000",X"9C00",X"6001",X"9B08",
          X"8E87",X"9A38",X"F000",X"F000");
begin
          dat_out <= rom( conv_integer(adr));

end architecture;


