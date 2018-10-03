----- rom_choose ------
--rom的地址选择模块，思路是每一个clk上升沿来时addra加一，如果addr记到一个阈值，则说明一次数据传输完成，此时finish_flag置1，通知controller模块开始重启各个模块，自动进行下一次传输
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity rom_choose is
   	port(
		clk         : in    std_logic;
		rst         : in    std_logic;
		ctl         : in    std_logic;
		addra       : out   std_logic_vector(10 downto 0);
		finish_flag : inout std_logic
		);
end rom_choose;

architecture Behavioral of rom_choose is
begin
    process(clk, rst, ctl)
	    variable temp_addra: std_logic_vector(10 downto 0):="00000000000";
	begin
		if(rst='1' or ctl = '1') then
		    temp_addra := "00000000000";
			finish_flag <= '0';
	    elsif(clk'event and clk = '1') then
			if(temp_addra = "00011111001") then --11111001，249   11110100，244
				temp_addra := "00000000000";
				finish_flag <= '1';					
			else
		        temp_addra := temp_addra + 1;
			end if;
		end if;
		addra <= temp_addra;
	end process;
end Behavioral;