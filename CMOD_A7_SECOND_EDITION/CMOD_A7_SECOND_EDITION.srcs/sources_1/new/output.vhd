------ output carrier -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity output is
    port(
    	clk       : in std_logic;
		rst       : in std_logic;
		ctl       : in std_logic;
		dataout   : in std_logic_vector (1 downto 0);
		bitstream : out std_logic
		);
end output;

architecture Behavioral of output is
begin
	process (rst, ctl, clk, dataout(1), dataout(0))
        variable cnt  : integer range 0 to 3;
        variable temp : std_logic;
	begin
	    if(rst = '1' or ctl = '1')       then
	        cnt := 0;
	    elsif (clk'event and clk = '1')  then
	    	if (cnt = 1)                 then
	            cnt := 0;
	            if (dataout(1) = '0')    then
	                temp := '0';
	            elsif (dataout(1) = '1') then
	                temp := '1';
	            end if;
	        elsif (cnt = 0)              then
	            cnt := cnt + 1;
	            if (dataout(0) = '0')    then
	                temp := '0';
                elsif (dataout(0) = '1') then
                    temp := '1';
                end if;
            end if;	           
	    end if;
	    bitstream <= temp;
	end process;
end Behavioral;