-----0.125 MHz used for Barker Code dectection ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity clk_0_125MHz is
    port(
		clk     : in  std_logic;
		clk_8us : out std_logic
		);
end clk_0_125MHz;

architecture Behavioral of clk_0_125MHz is
begin
	process(clk)
	   variable cnt : integer range 0 to 7;
	   variable temp: std_logic := '0';
	begin
		if(rising_edge(clk)) then
			cnt := cnt+1;
			if(cnt =  2) then
				temp:= not temp;
				cnt := 0;
			end if ;
		end if;
		clk_8us <= temp;
	end process;
end Behavioral;