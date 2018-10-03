-----1 MHz used for Barker Code dectection ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity clk_1MHz is
   	port(
   		clk    : in  std_logic;
	    bk_clk : out std_logic);
end clk_1MHz;

architecture Behavioral of clk_1MHz is
begin
	process(clk)
	    variable bkclk_cnt : integer range 0 to 60;
	    variable temp: std_logic :='0';
	begin
		if(rising_edge(clk)) then
			bkclk_cnt := bkclk_cnt+1;
			if(bkclk_cnt =  50) then
				temp:= not temp;
				bkclk_cnt := 0;
			end if ;
		end if;
		bk_clk <= temp;
	end process;
end Behavioral;