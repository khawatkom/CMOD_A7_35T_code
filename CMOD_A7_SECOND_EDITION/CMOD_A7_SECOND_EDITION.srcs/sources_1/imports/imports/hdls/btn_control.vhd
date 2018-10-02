------  use button to control  -----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity btn_control is
   port(mclk:in std_logic;
		  rst:in std_logic;
		  enable:inout std_logic;
		  btnC:in std_logic;
		  --jc1:out std_logic;
		  --jc2:out std_logic;
		  --jc3:out std_logic;
		  jc4:out std_logic;
		  ld0:out std_logic);
end btn_control;
	
architecture Behavioral of btn_control is
begin
	process(mclk, rst)
		variable btnC_flag : std_logic;
	begin
		if(rst = '1') then
			enable <= '0';
			ld0 <= '0';		
			btnC_flag :='0';
		elsif (rising_edge(mclk)) then
			if (btnC = '1' and btnC_flag = '0') then
				enable <= '1';
				ld0 <= '1';
				btnC_flag := '1';
			elsif (btnC = '0') then
				btnC_flag := '0';
			end if;
		end if;
	end process;
	--jc1 <= enable;
	--jc2 <= enable;
	--jc3 <= enable;
	jc4 <= enable;
end Behavioral;