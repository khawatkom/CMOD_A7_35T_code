------  use button to control  -----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity btn_control is
   	port(
		mclk                   : in    std_logic;
		rst                    : in    std_logic;
		enable                 : inout std_logic;
		btn_enable_tag_Rx      : in    std_logic;
		Enable_to_Tag          : out   std_logic;
		LED_flag_of_FPGA_start : out   std_logic
		);
end btn_control;
	
architecture Behavioral of btn_control is
begin
	process(mclk, rst)
		variable btn_enable_tag_Rx_flag : std_logic;
	begin
		if(rst = '1') then
			enable <= '0';
			LED_flag_of_FPGA_start <= '0';		
			btn_enable_tag_Rx_flag :='0';
		elsif (rising_edge(mclk)) then
			if (btn_enable_tag_Rx = '1' and btn_enable_tag_Rx_flag = '0') then
				enable <= '1';
				LED_flag_of_FPGA_start <= '1';
				btn_enable_tag_Rx_flag := '1';
			elsif (btn_enable_tag_Rx = '0') then
				btn_enable_tag_Rx_flag := '0';
			end if;
		end if;
	end process;

	Enable_to_Tag <= enable;

end Behavioral;