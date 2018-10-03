-----  Barker Code detector  -----
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity bk_detector is
   	port(
		bk_clk         : in    std_logic;   --4倍于250kbps的时钟，4us采样4欿
		rst            : in    std_logic;   --全局复位
		ctl            : in    std_logic;   --循环控制
		enable         : in    std_logic;   --模块开关，在前级按键按下后置为启动
		Input_from_Tag : in    std_logic;   --信号值输兿
		sig_flag       : inout std_logic    --是否棿测到信号的标忿
		);  
end bk_detector;

architecture Behavioral of bk_detector is
		
	signal sig_flag1 : std_logic;
	signal sig_flag2 : std_logic;
	signal sig_flag3 : std_logic;
	signal sig_flag4 : std_logic;										--10110111000
	signal barker : std_logic_vector(0 to 43):= "11010010110111010010110111011101001000100010";		--1111100110101，13位巴克码
	signal bkdata : std_logic_vector(4*barker'LENGTH downto 0);
begin
	process(bk_clk, rst, enable, sig_flag,ctl)--复位操作 以下丿长串赋忼可以用for语句代替，由于vhdl语言的特殊濧，在最弿始的时忙没有用for语句（不清楚for背后的时序）采用了最保险的一个信号一个信号地赋忼，这是极为体现硬件描述语言风格的?后来发现for在这里可以是可以的?这是个比较老版本的代码，未来的版本就直接for了?

	variable countnum1 : integer ;	
	variable countnum2 : integer ;
	variable countnum3 : integer ;
	variable countnum4 : integer ;	

	begin
		if(rst = '1' or ctl='1') then
			sig_flag1 <= '0';
			sig_flag2 <= '0';
			sig_flag3 <= '0';
			sig_flag4 <= '0';

			countnum1 :=0;
			countnum2 :=0;
			countnum3 :=0;
			countnum4 :=0;

			for iii in bkdata'HIGH downto 3 loop
				bkdata(iii)<= '0';
			end loop;

		elsif(rising_edge(bk_clk) and enable = '1' and sig_flag1 ='0') then
			countnum1 :=0;
			countnum2 :=0;
			countnum3 :=0;
			countnum4 :=0;

			for i in bkdata'HIGH downto 1 loop
				bkdata(i-1) <= bkdata(i);
			end loop;--badata第44位的移位寄存器，这里就是移位赋值的操作
			bkdata(bkdata'HIGH) <= Input_from_Tag;

			for ii in barker'HIGH downto 0 loop
				if (bkdata(4*ii) = barker(ii) ) then
					countnum1 :=countnum1 +1;
				end if;
				if (bkdata(4*ii+1) = barker (ii) ) then
					countnum2 :=countnum2 +1;
				end if;
				if (bkdata(4*ii+2) = barker (ii) ) then
					countnum3 :=countnum3 +1;
				end if;
				if (bkdata(4*ii+3) = barker (ii) ) then
					countnum4 :=countnum4 +1;
				end if;
			end loop;

			if ( countnum1 = barker'LENGTH or countnum2 = barker'LENGTH or countnum3 =barker'LENGTH or countnum4 =barker'LENGTH) then
				sig_flag1 <= '1';
			end if;

		end if;
	end process;

	process(bk_clk, rst, enable, sig_flag, sig_flag1, ctl)
	begin
	    if(rst = '1' or ctl='1') then
	        sig_flag <= '0';
	    elsif(rising_edge(bk_clk)) then
	        if(sig_flag1 = '1' or sig_flag2 = '1' or sig_flag3 = '1' or sig_flag4 = '1') then
            	sig_flag <= '1';
            end if;
        end if;
	 end process;
end Behavioral;

-------  Barker Code detector  -----
----
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
--entity bk_detector is
--   port(bk_clk: in std_logic;--4倍于250kbps的时钟，4us采样4欿
--		  rst: in std_logic;--全局复位
--		  ctl: in std_logic;--循环控制
--		  enable: in std_logic;--模块弿关，在前级按键按下后置为启动
--		  Input_from_Tag: in std_logic;--信号值输兿
--		  sig_flag: inout std_logic);--是否棿测到信号的标忿
--end bk_detector;

--architecture Behavioral of bk_detector is
--		signal bkdata : std_logic_vector(43 downto 0);
--		signal sig_flag1 : std_logic := '0';
--		signal sig_flag2 : std_logic := '0';
--		signal sig_flag3 : std_logic := '0';
--		signal sig_flag4 : std_logic := '0';
--begin
--	process(bk_clk, rst, enable, sig_flag,ctl)--复位操作 以下丿长串赋忼可以用for语句代替，由于vhdl语言的特殊濧，在最弿始的时忙没有用for语句（不清楚for背后的时序）采用了最保险的一个信号一个信号地赋忼，这是极为体现硬件描述语言风格的?后来发现for在这里可以是可以的?这是个比较老版本的代码，未来的版本就直接for了?

--	begin
--		if(rst = '1' or ctl='1') then
--			sig_flag1 <= '0';
--			sig_flag2 <= '0';
--			sig_flag3 <= '0';
--			sig_flag4 <= '0';
--			bkdata(43)<='0';
--			bkdata(42)<='0';
--			bkdata(41)<='0';
--			bkdata(40)<='0';
--			bkdata(39)<='0';
--			bkdata(38)<='0';
--			bkdata(37)<='0';
--			bkdata(36)<='0';
--			bkdata(35)<='0';
--			bkdata(34)<='0';
--			bkdata(33)<='0';
--			bkdata(32)<='0';
--			bkdata(31)<='0';
--			bkdata(30)<='0';
--			bkdata(29)<='0';
--			bkdata(28)<='0';
--			bkdata(27)<='0';
--			bkdata(26)<='0';
--			bkdata(25)<='0';
--			bkdata(24)<='0';
--			bkdata(23)<='0';
--			bkdata(22)<='0';
--			bkdata(21)<='0';
--			bkdata(20)<='0';
--			bkdata(19)<='0';
--			bkdata(18)<='0';
--			bkdata(17)<='0';
--			bkdata(16)<='0';
--			bkdata(15)<='0';
--			bkdata(14)<='0';
--			bkdata(13)<='0';
--			bkdata(12)<='0';
--			bkdata(11)<='0';
--			bkdata(10)<='0';
--			bkdata(9)<='0';
--			bkdata(8)<='0';
--			bkdata(7)<='0';
--			bkdata(6)<='0';
--			bkdata(5)<='0';
--			bkdata(4)<='0';
--			bkdata(3)<='0';

			
--		elsif(rising_edge(bk_clk) and enable = '1' and sig_flag1 ='0') then
--			for i in 43 downto 1 loop
--				bkdata(i-1) <= bkdata(i);
--			end loop;--badata丿44位的移位寄存器，这里就是移位赋忼的操作
--			bkdata(43) <= Input_from_Tag;
--			--这是比较早期的版本，还没有引入互相关，这里就是每隔四个位进行丿10110111000的比对，如果完全丿样那么就认为棿测到＿4倍频的话这样子就有四次机会被棿测到，克服了采样时钟可能采在奇濪位置的问题。在后面的版本中用互相关函数，在性能上应该是有很大提升的?	
--			if(bkdata(43)='0' and bkdata(39)='0' and  bkdata(35)='0' and bkdata(31)='1' and bkdata(27)='1' and
--			bkdata(23)='1' and bkdata(19)='0' and bkdata(15)='1' and bkdata(11)='1' and bkdata(7)='0' and bkdata(3)='1' ) then
--				sig_flag1 <= '1';
--			end if ;
--			if(bkdata(42)='0' and bkdata(38)='0' and  bkdata(34)='0' and bkdata(30)='1' and bkdata(26)='1' and
--			bkdata(22)='1' and bkdata(18)='0' and bkdata(14)='1' and bkdata(10)='1' and bkdata(6)='0' and bkdata(2)='1' ) then
--				sig_flag2 <= '1';
--			end if ;
--			if(bkdata(41)='0' and bkdata(37)='0' and  bkdata(33)='0' and bkdata(29)='1' and bkdata(25)='1' and
--			bkdata(21)='1' and bkdata(17)='0' and bkdata(13)='1' and bkdata(9)='1' and bkdata(5)='0' and bkdata(1)='1' ) then
--				sig_flag3 <= '1';
--			end if ;
--			if(bkdata(40)='0' and bkdata(36)='0' and  bkdata(32)='0' and bkdata(28)='1' and bkdata(24)='1' and
--			bkdata(20)='1' and bkdata(16)='0' and bkdata(12)='1' and bkdata(8)='1' and bkdata(4)='0' and bkdata(0)='1' ) then
--				sig_flag4 <= '1';
--			end if ;
--			---------------------------------------------------------------------------------------------------------------------


--			--选用11位巴克码，同百度百科，11100010010
--			if(bkdata(43)='0' and bkdata(39)='1' and  bkdata(35)='0' and bkdata(31)='0' and bkdata(27)='1' and
--			bkdata(23)='0' and bkdata(19)='0' and bkdata(15)='0' and bkdata(11)='1' and bkdata(7)='1' and bkdata(3)='1' ) then
--				sig_flag1 <= '1';
--			end if ;
--			if(bkdata(42)='0' and bkdata(38)='1' and  bkdata(34)='0' and bkdata(30)='0' and bkdata(26)='1' and
--			bkdata(22)='0' and bkdata(18)='0' and bkdata(14)='0' and bkdata(10)='1' and bkdata(6)='1' and bkdata(2)='1' ) then
--				sig_flag2 <= '1';
--			end if ;
--			if(bkdata(41)='0' and bkdata(37)='1' and  bkdata(33)='0' and bkdata(29)='0' and bkdata(25)='1' and
--			bkdata(21)='0' and bkdata(17)='0' and bkdata(13)='0' and bkdata(9)='1' and bkdata(5)='1' and bkdata(1)='1' ) then
--				sig_flag3 <= '1';
--			end if ;
--			if(bkdata(40)='0' and bkdata(36)='1' and  bkdata(32)='0' and bkdata(28)='0' and bkdata(24)='1' and
--			bkdata(20)='0' and bkdata(16)='0' and bkdata(12)='0' and bkdata(8)='1' and bkdata(4)='1' and bkdata(0)='1' ) then
--				sig_flag4 <= '1';
--			end if ;
--		end if;
--	end process;

--	process(bk_clk, rst, enable, sig_flag, sig_flag1, ctl)
--	begin
--	   if(rst = '1' or ctl='1') then
--	       sig_flag <= '0';
--	   elsif(rising_edge(bk_clk)) then
--	     if(sig_flag1 = '1' or sig_flag2 = '1' or sig_flag3 = '1' or sig_flag4 = '1') then
--             sig_flag <= '1';
--         end if;
--       end if;
--	 end process;
--end Behavioral;