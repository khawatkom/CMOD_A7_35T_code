--shift_output
--这里采用的是延迟计数的方式得到16个不同相位的的频移时钟
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity shift_output is
   port(
		control : in  std_logic;
		rst     : in  std_logic;
		ctl     : in  std_logic;
		d       : in  std_logic;
		freq_1  : out std_logic;
		freq_2  : out std_logic;
		freq_3  : out std_logic;
		freq_4  : out std_logic;
		freq_5  : out std_logic;
		freq_6  : out std_logic;
		freq_7  : out std_logic;
		freq_8  : out std_logic;
		freq_9  : out std_logic;
		freq_10 : out std_logic;
		freq_11 : out std_logic;
		freq_12 : out std_logic;
		freq_13 : out std_logic;
		freq_14 : out std_logic;
		freq_15 : out std_logic;
		freq_16 : out std_logic
		);
end shift_output;

architecture Behavioral of shift_output is
begin
    process(control, d, rst, ctl)
	    variable delay_counter: integer range 0 to 16;
		variable temp : std_logic_vector(7 downto 0);
    begin
	if(rst = '1' or ctl = '1') then
		delay_counter := 0;
		for i in 0 to 7 loop
			temp(i) := '0';
		end loop;
		freq_1  <= '0';
		freq_2  <= '0';
		freq_3  <= '0';
		freq_4  <= '0';
		freq_5  <= '0';
		freq_6  <= '0';
		freq_7  <= '0';
		freq_8  <= '0';
		freq_1  <= '0';
		freq_9  <= '0';
		freq_10 <= '0';
		freq_11 <= '0';
		freq_12 <= '0';
		freq_13 <= '0';
		freq_14 <= '0';
		freq_15 <= '0';
		freq_16 <= '0';
    elsif(rising_edge(d) and control = '1') then	
		if(delay_counter = 0 or delay_counter = 8) then
			temp(0) := not temp(0);
		elsif (delay_counter = 1 or delay_counter =9) then
			temp(1) := not temp(1);
		elsif (delay_counter = 2 or delay_counter =10) then
			temp(2) := not temp(2);
		elsif (delay_counter = 3 or delay_counter =11) then
			temp(3) := not temp(3);
		elsif (delay_counter = 4 or delay_counter =12) then
			temp(4) := not temp(4);
		elsif (delay_counter = 5 or delay_counter =13) then
			temp(5) := not temp(5);
		elsif (delay_counter = 6 or delay_counter =14) then
			temp(6) := not temp(6);
		else 
			temp(7) := not temp(7);
		end if;
		delay_counter :=  delay_counter +1;
		if (delay_counter = 16) then
			delay_counter := 0;
		end if;
    end if;	
		freq_1  <= temp(0);
		freq_2  <= temp(1);
		freq_3  <= temp(2);
		freq_4  <= temp(3);
		freq_5  <= temp(4);
		freq_6  <= temp(5);
		freq_7  <= temp(6);
		freq_8  <= temp(7);
		freq_9  <= not temp(0);
		freq_10 <= not temp(1);
		freq_11 <= not temp(2);
		freq_12 <= not temp(3);
		freq_13 <= not temp(4);
		freq_14 <= not temp(5);
		freq_15 <= not temp(6);
		freq_16 <= not temp(7);
	end process;
end Behavioral;
