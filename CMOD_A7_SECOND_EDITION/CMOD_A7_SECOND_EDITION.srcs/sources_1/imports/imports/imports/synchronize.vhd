----- synchronize -----
--同步模块，思路是如果检测到preamble就开始计数，计数到2us反转一次，生成一个4us的时钟
--因为一开始存在发射机到tag之间的延迟，因此从144，不是零，开始计数，计到200
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity synchronize is
   port(mclk: in std_logic;
	     --ctrl: inout std_logic;
		  --inv_ctrl: inout std_logic;
		  rst: in std_logic;
		  ctl: in std_logic;
		  jb1: in std_logic;
		  sig_flag: in std_logic;
		  ld2 : out std_logic;
		  syn_flag :inout std_logic;
		  bitsyn: out std_logic;
		  countnumber: out integer range 0 to 511);		  
end synchronize;

architecture Behavioral of synchronize is
--signal temp : std_logic;	
begin
	process(mclk ,rst, sig_flag,syn_flag,ctl)
	   variable edge_cnt: integer:=0;
		variable clk_cnt: integer:=0;
		variable pre: std_logic := '0';
	begin
		if(rst ='1' or ctl='1') then
			--pre := '0';

			edge_cnt := 0;
			clk_cnt := 0;
			syn_flag <= '0';
			ld2 <= '0';
			--ctrl <= '0';
			--inv_ctrl <= '1';
		elsif (rising_edge(mclk)and sig_flag ='1' and syn_flag ='0') then
				--if (jb1/= pre )then
					ld2 <= '1';
					syn_flag <='1';
					--ctrl <= '1';
					--inv_ctrl <= '0';
				--else 
				--   pre := jb1;
				--end if;
		end if;
	end process;

	process(mclk,rst, syn_flag,ctl)
		variable chr_clk_cnt :integer;
		variable chr_clk_cnt2: integer;
		variable temp : std_logic;
		--variable flag : std_logic;
	begin
	
		    --begin counting from zero , which means that bitout starts immediately at the moment of barker-detected signal turns '1'.
		    if(rst = '1' or ctl='1') then
				   chr_clk_cnt := 198; --199时temp_output就开始输出了，所以设定到198
				   temp := '1';
				   --flag := '0';
			elsif(rising_edge(mclk)) then
				if(syn_flag = '1') then
				      chr_clk_cnt := chr_clk_cnt +1 ;
				      if(chr_clk_cnt = 200) then
					      temp := not temp;
					      chr_clk_cnt := 0;
				      end if;
			    end if;
			end if;
		if(rising_edge(mclk)) then
			bitsyn  <= not temp;
			countnumber <= chr_clk_cnt;
		end if;
	end process;	
end Behavioral;

--原本的，带有144延时的同步时钟，现在去掉	
--	process(mclk,rst, syn_flag,ctl)
--		variable chr_clk_cnt :integer;
--		variable chr_clk_cnt2: integer;
--		variable temp : std_logic;
--		variable flag : std_logic;
--	begin
--		if(rising_edge(mclk)) then
--		   if(rst = '1' or ctl='1') then
--			   chr_clk_cnt := 0;
--			   temp := '1';
--			   flag := '0';
--			else
--			   if(syn_flag = '1') then
--			      if(flag = '0') then
--				      chr_clk_cnt := chr_clk_cnt +1 ;
--				      if(chr_clk_cnt = 144) then
--					      chr_clk_cnt := 0;
--					      temp := not temp;
--					      flag := '1';
--				      end if;
--			      else 
--				      chr_clk_cnt := chr_clk_cnt +1 ;
--				      if(chr_clk_cnt = 200) then
--					      temp := not temp;
--					      chr_clk_cnt := 0;
--				      end if;
--			      end if;			
--				end if;	
--			end if;
--			bitsyn  <= not temp;
--			countnumber <= chr_clk_cnt;
--		end if;
--	end process;	
--end behavioral;


