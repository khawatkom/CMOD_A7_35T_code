-------  controller  ------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity controller is
    port(
		control_clk    : in  std_logic;
		syn_start_flag : in  std_logic;
		finish_flag    : in  std_logic;
		ctl            : out std_logic
		);
end controller;


architecture Behavioral of controller is
begin
	process(control_clk, finish_flag)
    begin
		if(rising_edge(control_clk) ) then
			if(syn_start_flag = '0') then
				ctl<='0';
			end if;
		end if;	

		--这种写法有个问题就是finish_flag和ctl相互影响，finish_flag上升沿使得ctl置于1，ctl置于1使得finish_flag置0，finish_flag时序可能有问题，在小板子时可能反应不过来
		if (rising_edge(finish_flag)) then
		   ctl <='1';
		end if;		

	end process;
end Behavioral;


--architecture Behavioral of controller is
--begin
--	process(control_clk)
--   begin
--		if(rising_edge(control_clk) ) then
--			if(syn_start_flag = '0') then
--				ctl<='0';
--			else
--				if (finish_flag = '1') then
--				   ctl <='1';
--				end if;
--			end if;
--		end if;			
--	end process;
--end Behavioral;