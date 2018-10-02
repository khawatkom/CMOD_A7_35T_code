
-------  controller  ------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity controller is
    port(bk_clk:in std_logic;
		   syn_flag :in std_logic;
			finish_flag: in std_logic;
		   ctl:out std_logic
		  );
end controller;


architecture Behavioral of controller is
begin
	process(bk_clk, finish_flag)
   begin
		if(rising_edge(bk_clk) ) then
			if(syn_flag = '0') then
				ctl<='0';
			end if;
		end if;	

		if (rising_edge(finish_flag)) then
		   ctl <='1';
		end if;		

	end process;
end Behavioral;


--architecture Behavioral of controller is
--begin
--	process(bk_clk)
--   begin
--		if(rising_edge(bk_clk) ) then
--			if(syn_flag = '0') then
--				ctl<='0';
--			else
--				if (finish_flag = '1') then
--				   ctl <='1';
--				end if;
--			end if;
--		end if;			
--	end process;
--end Behavioral;