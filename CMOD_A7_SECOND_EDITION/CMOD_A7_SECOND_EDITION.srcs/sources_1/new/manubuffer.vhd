
-----------buffer ----------
--在一位比特流之前加入8位tag-to-receiver的前导码序列用以接收机那边的星座图相位纠正
--思路是增加一个vector作为一个FIFO的容器,容器里面事先存好to_rx的前导码序列
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity manubuffer is
    port(
		clk    : in std_logic;
		rst    : in std_logic;
		ctl    : in std_logic;
		bitin  : in std_logic;
		bitout : out std_logic;
        flag_ook : out std_logic
		);
end manubuffer;

architecture Behavorial of manubuffer is
--    signal vector: std_logic_vector (7 downto 0);
begin
    process(clk, rst, ctl)
        variable vector    : std_logic_vector (7 downto 0);
        variable count_ook : integer ;
    begin
        if(rst = '1' or ctl = '1') then
            vector := "10101010";
            flag_ook <= '1';
            count_ook := 0;
        elsif (clk'event and clk = '1') then
            bitout    <= vector(7);
            vector(7) := vector(6);
            vector(6) := vector(5);
            vector(5) := vector(4);
            vector(4) := vector(3);
            vector(3) := vector(2);
            vector(2) := vector(1);
            vector(1) := vector(0);
            if (bitin = '1' or bitin = '0') then
                vector(0)  := bitin;
            else
                vector(0) := '1';
            end if;
            if (count_ook = 2) then
                flag_ook <= '0';
            end if;
            count_ook := count_ook + 1;
        end if;
    end process;
end Behavorial;