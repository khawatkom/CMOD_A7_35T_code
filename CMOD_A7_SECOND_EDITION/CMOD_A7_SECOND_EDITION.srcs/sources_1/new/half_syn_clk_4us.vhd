----- halfen the syn_clk_4us ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity half_syn_clk_8us is
   	port(
		syn_clk_4us        : in std_logic;
		rst                : in std_logic;
		ctl                : in std_logic;
		rom_output_clk_8us : out std_logic
		);
end half_syn_clk_8us;

architecture Behavioral of half_syn_clk_8us is
begin
	process(syn_clk_4us, ctl, rst)
	    variable cnt : integer range 0 to 7;
	    variable temp: std_logic :='0';
	begin
	    if(rst = '1' or ctl = '1') then
	       temp := '0';
	       --cnt  := '0'; --cnt初始化小有问题，重写下
		elsif(rising_edge(syn_clk_4us)) then
			cnt := cnt+1;
			if(cnt =  1) then
				temp:= not temp;
				cnt := 0;
			end if ;
		end if;
		rom_output_clk_8us <= temp;
	end process;
end Behavioral;