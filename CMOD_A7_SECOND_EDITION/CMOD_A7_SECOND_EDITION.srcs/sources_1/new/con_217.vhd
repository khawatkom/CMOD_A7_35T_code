------ (2, 1, 7) convolution code -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity con_217 is
   port(
		rst     : in  std_logic;
		ctl     : in  std_logic;
		clk     : in  std_logic;
		datain  : in  std_logic_vector (0 downto 0);
		dataout : out std_logic_vector (1 downto 0));
end con_217;

architecture Behavioral of con_217 is
begin
	process(clk, rst, ctl)
    	variable reg: std_logic_vector (6 downto 0) := "0000000";
    begin
    if (rst = '1' or ctl = '1') then
		reg(0) := '0';
		reg(1) := '0';
		reg(2) := '0';
		reg(3) := '0';
		reg(4) := '0';
		reg(5) := '0';
		reg(6) := '0';
  	elsif (clk'event and clk = '1') then
		reg(0) := reg(1);
		reg(1) := reg(2);
		reg(2) := reg(3);
		reg(3) := reg(4);
		reg(4) := reg(5);
		reg(5) := reg(6);       
		reg(6) := datain(0);
		dataout(1) <= reg(6) xor reg(4) xor reg(3) xor reg(1) xor reg(0);
		dataout(0) <= reg(6) xor reg(5) xor reg(4) xor reg(3) xor reg(0);
  	end if;
end process;
end Behavioral;