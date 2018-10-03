-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--本代码实现的是一块小型FPGA板卡控制一块tag的功能,载波时钟与码元时钟同步的方法为动态相位
--调节频偏量的模块是:"generate_16xDeltaF",其输出时钟为目标时钟的16倍
--发送的数据可以在"rom224"模块中修改
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity SSB is
    port(  
		primary_clk                : in 	std_logic;              --主晶振12MHz
		btn_enable_tag_Rx          : in 	STD_LOGIC;			    --使能tag的接收模块
		rst                        : in 	STD_LOGIC;			    --重启tag
		Input_from_Tag             : in 	std_logic;              --比较器输出信号即前导序列
		Enable_to_Tag              : out 	std_logic;              --使能tag的接收模块        
		LED_flag_of_FPGA_start     : out 	STD_LOGIC;		        --标识FPGA是否使能
		LED_flag_of_TiggerSequence : out 	std_logic;              --标识tag#4是否接收到前导序列
		Output_cos                 : out 	std_logic;              --频移量cos输出
		Output_sin                 : out 	std_logic;              --频移量sin输出
		ctrl                       : inout  std_logic;              --控制Tag的紧接天线输入后的二选一开关,选择是走哪一条路
        inv_ctrl                   : inout  std_logic               --与ctrl相反,两者结合使用,同一功能
		);
end SSB;


architecture Behavioral of SSB is
	
--------------------------------------------变量定义区---------------------------------------
---------------------------------------------------------------------------------------------	
	signal clk : STD_LOGIC := '0';
	
	signal temp_output_cos_0_degree:   std_logic := '0';
	signal temp_output_sin_0_degree:   std_logic := '0';
	signal temp_output_cos_180_invert: std_logic := '0';
	signal temp_output_sin_180_invert: std_logic := '0';
	
	signal clk_8us : std_logic;          --controller时钟,0.125MHz,用于传输bit个数,可以考虑以后提高到0.25MHz
	signal bk_clk_4MHz  : std_logic;          --巴克码时钟,4MHz,用于44位扩频
	
	--tag 需要的变量
	signal clk_1       : std_logic:='0';      --频移时钟
	signal enable      : std_logic:='0';	  --是否使能
	signal sig_flag    : std_logic:='0';      --是否检测到目标前导序列
	signal bk_clk      : std_logic:='0';      --用以采样前导序列的时钟,为1MHz（周期为4us的四分之一）
	signal ctl         : std_logic:='0';      --controller模块的使能信号
	signal syn_start_flag    : std_logic:='0';      --同步完成标识
	signal addra       : std_logic_vector (10 downto 0):="00000000000";  --rom中的地址
	signal data        : std_logic_vector (0 downto 0):="0";             --rom数据输出,值得一提的是rom数据输出必须为vector,哪怕只有一位也是vector
	signal dataout     : std_logic_vector (1 downto 0) := "00";          --卷积码数据输出
	signal bitstream   : std_logic := '0';                               --二维vector的卷积码输出变为一维bit流
	signal syn_clk_4us      : std_logic := '0';                               --同步时钟,4us
	signal rom_output_clk_8us    : std_logic := '0';                               --同步时钟的一半,8us,rom中的数据就是用这个时钟输出
	signal finish_flag : std_logic;                                      --标志一次传输的完成,490+之前的几位码
	signal countnumber : integer range 0 to 511;                         --同步模块的计数值

	--以下是相位校准模块的输入,将2pi均分16块,然后选择其中一个相位最接近的。
	--这样的写法不好,以后应该修改,使用标准的DPL数字锁相环
	signal freq_1                  : std_logic;
	signal freq_2                  : std_logic;
	signal freq_3                  : std_logic;
	signal freq_4                  : std_logic;
	signal freq_5                  : std_logic;
	signal freq_6                  : std_logic;
	signal freq_7                  : std_logic;
	signal freq_8                  : std_logic;
	signal freq_9                  : std_logic;
	signal freq_10                 : std_logic;
	signal freq_11                 : std_logic;
	signal freq_12                 : std_logic;
	signal freq_13                 : std_logic;
	signal freq_14                 : std_logic;
	signal freq_15                 : std_logic;
	signal freq_16                 : std_logic;   
	signal choose_result_of_16freq : integer range 0 to 16; --选择16个相位中的哪一个作为同步相位

  	signal bitout : std_logic; --FPGA要传输的比特流,来自rom或者传感器收集,n位+490 



-------------------------------------------------------------------------------------------------------------
------------------------------------------COMPONENT定义区-----------------------------------------------------
-------------------------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------
	--------------------------------------各个时钟生成模块---------------------------------------
	component clk_1MHz
		port(
			clk    : in  std_logic;
			bk_clk : out std_logic
			);
	end component;
	
	component clk_4MHz
    	port(
			clk         : in  std_logic;
			bk_clk_4MHz : out std_logic
			);
	end component;

	component clk_0_125MHz
	    port(
			clk     : in  std_logic;
			clk_8us : out std_logic
	        );
	end component;

	--IP核生成OFDM频偏倍频时钟,范围在100~500MHz之间
	component clknew4
	    port(
			clk_out1 : out std_logic;
			clk_in1  : in  std_logic
            );
	end component;
	
	--IP核生成100MHz倍频时钟
	component clk_100MHz
	    port( 
			clk_out1 : out std_logic;
			clk_in1  : in  std_logic
			);
	end component;

  	--生成同步时钟的一半,8us
  	--功能:rom中的数据就是用这个时钟输出,syn_clk_4us为同步时钟,4us,rom_output_clk_8us为输出时钟,8us
	component half_syn_clk_8us
	    port(   
			syn_clk_4us		   : in  std_logic;
			rst         	   : in  std_logic;
			ctl        	       : in  std_logic;
			rom_output_clk_8us : out std_logic
	        );
	end component;	
	-------------------------------------------------------------------------------------------


    -------------------------------------------------------------------------------------------
	--------------------------------------数据库IP核使用相关模块---------------------------------
	--数据库的地址选择模块
	--功能:clk为8us的rom_output_clk_8us时钟,每一个clk上升沿来时addra加一,如果addr记到一个阈值,
	--则说明一次数据传输完成,此时finish_flag置1,通知controller模块开始重启各个模块,自动进行下一次传输
	component rom_choose
	    port(
			clk         : in    std_logic;
			rst         : in    std_logic;
			ctl         : in    std_logic;
			addra       : out   std_logic_vector(10 downto 0);
			finish_flag : inout std_logic
			);
	end component;
	
  	--tag的数据库
  	--功能:a为输入的序列,作为取内容的地址,从a地址取出1位数据spo（可以修改位数）
	COMPONENT rom224
		PORT(
			a   : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
			spo : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
			);
	END COMPONENT;
	-------------------------------------------------------------------------------------------


	-------------------------------------------------------------------------------------------
    --FPGA、tag接收模块的按键使能模块
    --功能:使用时钟为主晶振,100MHz,按下btn_enable_tag_Rx使能FPGA,
	component btn_control
	    port(
			mclk                   : in    std_logic;
			rst                    : in    std_logic;
			enable                 : inout std_logic;
			btn_enable_tag_Rx      : in    std_logic;
			Enable_to_Tag          : out   std_logic;
			LED_flag_of_FPGA_start : out   std_logic
			);
	end component;
	
    --巴克码检测模块,
    --功能:检测成功后输出sig_flag为1,使用rst或者ctl重置, 要求enable为1,即tag的接收模块正在尝试接收触发序列
	component bk_detector
	    port(
			bk_clk         : in    std_logic;
			rst            : in    std_logic;
			ctl            : in    std_logic;
			enable         : in    std_logic;
			Input_from_Tag : in    std_logic;
			sig_flag       : inout std_logic
			);
	end component;
	
	--同步模块,生成250KHz,4us的OFDM码元时钟
	--功能:clk为主晶振,使用rst,clk重置,sig_flag为1时,即检测到触发序列,点亮LED,同步开始标志syn_start_flag置1,开始生成4us同步时钟syn_clk_4us,
	--生成的方法就是计数器countnumber计数100MHz时钟,计数200次一翻转,时钟就是4us
	-------------------------------------------------------------------------------------------
	--ctrl和inv_ctrl控制tag的两个状态:接收触发序列,输出信号
	component synchronize
	    port(
			mclk                       : in    std_logic;
			ctrl                       : inout std_logic;
            inv_ctrl                   : inout std_logic;
			rst                        : in    std_logic;
			ctl                        : in    std_logic;
			sig_flag                   : in    std_logic;
			LED_flag_of_TiggerSequence : out   std_logic;
			syn_start_flag             : inout std_logic;
			syn_clk_4us                : out   std_logic;
			countnumber                : out   integer range 0 to 511
			);
	end component;
	
	--重复发送模块
	--功能:在一次传输完成之后,将ctl置于1,相当于自动rst
	component controller is
	    port(
			control_clk    : in  std_logic;
			syn_start_flag : in  std_logic;
			finish_flag    : in  std_logic;
			ctl            : out std_logic
			);
	end component;
	-------------------------------------------------------------------------------------------

	
	----------------------------------------------------------------------------------------
	------------shift_output模块和dynamic_choose很值得考虑修改,使用标准DPL比较好--------------

	--该模块将频移时钟分成16个不同相位用以相位纠正
	component shift_output is
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
	end component;

	--相位纠正模块
	--功能:从16个不同相位的频移时钟中选取出一个与码元时钟最为同步的一个频移时钟,choose_result_of_16freq记录其序号
	component dynamic_choose
	    port(
			clk                     : in std_logic;
			rst                     : in std_logic;
			ctl                     : in std_logic;
			freq_1                  : in std_logic;
			freq_2                  : in std_logic;
			freq_3                  : in std_logic;
			freq_4                  : in std_logic;
			freq_5                  : in std_logic;
			freq_6                  : in std_logic;
			freq_7                  : in std_logic;
			freq_8                  : in std_logic;
			freq_9                  : in std_logic;
			freq_10                 : in std_logic;
			freq_11                 : in std_logic;
			freq_12                 : in std_logic;
			freq_13                 : in std_logic;
			freq_14                 : in std_logic;
			freq_15                 : in std_logic;
			freq_16                 : in std_logic;
			countnumber             : in integer range 0 to 511;
			choose_result_of_16freq : out integer range 0 to 16
		    );
	end component;
    ----------------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------
    ---------------------------------------输出模块组----------------------------------------
	--217卷积码模块
	--功能:clk使用rom_output_clk_8us,输入的是245位bit,输出卷积的490位bit
	component con_217
	    port(
			clk     : in std_logic;
			rst     : in std_logic;
			ctl     : in std_logic;
			datain  : in std_logic_vector (0 downto 0);
			dataout : out std_logic_vector (1 downto 0)
	    	);
	end component;
	
	--将二维卷积码输出变为一维比特流
	component output
	    port(
			clk       : in std_logic;
			rst       : in std_logic;
			ctl       : in std_logic;
			dataout   : in std_logic_vector (1 downto 0);
			bitstream : out std_logic
        	);
	 end component;
	 
	--输出缓冲模块,在490位之前加入一些bit的overhead,用于实现各种功能
	--功能:在一位比特流之前加入8位tag-to-receiver的前导码序列用以接收机那边的星座图相位纠正
	 component manubuffer
	    port( 
			clk    : in std_logic;
			rst    : in std_logic;
			ctl    : in std_logic;
			bitin  : in std_logic;
			bitout : out std_logic
            );
	 end component;
	 ---------------------------------------------------------------------------------------- 
	
begin
	---------------------------------------------------------------------------------------- 
	generate_1MHz     : clk_1MHz         port map(clk => clk, bk_clk => bk_clk);
	generate_4MHz     : clk_4MHz         port map(clk => clk, bk_clk_4MHz => bk_clk_4MHz);
	generate_0_125MHz : clk_0_125MHz     port map(clk => bk_clk, clk_8us => clk_8us);

	generate_100MHz   : clk_100MHz       port map(clk_out1 => clk, clk_in1 => primary_clk);
	generate_16xDeltaF: clknew4          port map(clk_out1 => clk_1, clk_in1 => clk);

	generate_half_8us : half_syn_clk_8us port map(syn_clk_4us => syn_clk_4us, rst => rst, ctl => ctl, rom_output_clk_8us => rom_output_clk_8us);
	---------------------------------------------------------------------------------------- 


	---------------------------------------------------------------------------------------- 
	u40: rom224         port map(a => addra, spo => data);
	u41: rom_choose     port map(clk     => rom_output_clk_8us, rst => rst,     ctl => ctl,  addra => addra,  finish_flag => finish_flag);
	---------------------------------------------------------------------------------------- 


	---------------------------------------------------------------------------------------- 
	u12: btn_control    port map(mclk => clk, rst => rst, enable => enable, btn_enable_tag_Rx => btn_enable_tag_Rx, 
								Enable_to_Tag => Enable_to_Tag, LED_flag_of_FPGA_start => LED_flag_of_FPGA_start);
	
	u13: controller     port map(control_clk => clk_8us, syn_start_flag => syn_start_flag, finish_flag => finish_flag, ctl => ctl);

	u44: bk_detector    port map(bk_clk  => bk_clk_4MHz, rst=> rst, ctl => ctl, enable => enable, Input_from_Tag => Input_from_Tag, sig_flag => sig_flag);	
	
	u45: synchronize    port map(mclk => clk, rst => rst, ctl => ctl, sig_flag => sig_flag, 
		 						LED_flag_of_TiggerSequence => LED_flag_of_TiggerSequence, syn_start_flag => syn_start_flag, 
					  			syn_clk_4us  => syn_clk_4us, countnumber => countnumber);
	----------------------------------------------------------------------------------------   


	----------------------------------------------------------------------------------------
	u46:shift_output    port map(control => syn_start_flag, rst     => rst,     ctl     => ctl,     d   => clk_1, 
                                freq_1  => freq_1,  freq_2  => freq_2,  freq_3  => freq_3,  freq_4  => freq_4,  
                                freq_5  => freq_5,  freq_6  => freq_6,  freq_7  => freq_7,  freq_8  => freq_8,
                                freq_9  => freq_9,  freq_10 => freq_10, freq_11 => freq_11, freq_12 => freq_12,
                                freq_13 => freq_13, freq_14 => freq_14, freq_15 => freq_15, freq_16 => freq_16); 

	u47:dynamic_choose  port map(clk     => syn_clk_4us,  rst     => rst,     ctl     => ctl, 
                                freq_1  => freq_1,  freq_2  => freq_2,  freq_3  => freq_3,  freq_4  => freq_4, 
                                freq_5  => freq_5,  freq_6  => freq_6,  freq_7  => freq_7,  freq_8  => freq_8, 
                                freq_9  => freq_9,  freq_10 => freq_10, freq_11 => freq_11, freq_12 => freq_12,
                                freq_13 => freq_13, freq_14 => freq_14, freq_15 => freq_15, freq_16 => freq_16, 
                                countnumber => countnumber, choose_result_of_16freq => choose_result_of_16freq); 
	----------------------------------------------------------------------------------------


	----------------------------------------------------------------------------------------
    u470: con_217 port map (clk => rom_output_clk_8us, rst => rst, ctl => ctl, datain => data, dataout => dataout);
    u471: output port map (clk => syn_clk_4us, rst => rst, ctl => ctl, dataout => dataout, bitstream => bitstream);    
    u480: manubuffer port map (clk => syn_clk_4us, rst => rst, ctl => ctl, bitin => bitstream, bitout => bitout);   
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--------------------------------主程序操作区---------------------------------------------
	--功能:依据dynamic_choose选择的数字,从十六个频移时钟选出一个，然后写入temp_output_cos&sin中，准备输出
	with choose_result_of_16freq select	   
	    temp_output_cos_0_degree <=       
			freq_1  when 0,
        	freq_2  when 1,
            freq_3  when 2,
            freq_4  when 3,
            freq_5  when 4,
            freq_6  when 5,
            freq_7  when 6,
            freq_8  when 7,
            freq_9  when 8,
            freq_10 when 9,
            freq_11 when 10,
            freq_12 when 11,
            freq_13 when 12,
            freq_14 when 13,
            freq_15 when 14,
            freq_16 when 15,
            '0'     when others;	                            
	with choose_result_of_16freq select       
	    temp_output_sin_0_degree <= 		
			freq_5  when 0,
            freq_6  when 1,
            freq_7  when 2,
            freq_8  when 3,
            freq_9  when 4,
            freq_10 when 5,
            freq_11 when 6,
            freq_12 when 7,
            freq_13 when 8,
            freq_14 when 9,
            freq_15 when 10,
            freq_16 when 11,
            freq_1  when 12,
            freq_2  when 13,
            freq_3  when 14,
            freq_4  when 15,
            '0'     when others;
	with choose_result_of_16freq select       
	    temp_output_cos_180_invert <= 		
			freq_9  when 0,
            freq_10 when 1,
            freq_11 when 2,
            freq_12 when 3,
            freq_13 when 4,
            freq_14 when 5,
            freq_15 when 6,
            freq_16 when 7,
            freq_1  when 8,
            freq_2  when 9,
            freq_3  when 10,
            freq_4  when 11,
            freq_5  when 12,
            freq_6  when 13,
            freq_7  when 14,
            freq_8  when 15,
            '0'     when others;
	                            
	with choose_result_of_16freq select       
	    temp_output_sin_180_invert <= 		
			freq_13 when 0,
            freq_14 when 1,
            freq_15 when 2,
            freq_16 when 3,
            freq_1  when 4,
            freq_2  when 5,
            freq_3  when 6,
            freq_4  when 7,
            freq_5  when 8,
            freq_6  when 9,
            freq_7  when 10,
            freq_8  when 11,
            freq_9  when 12,
            freq_10 when 13,
            freq_11 when 14,
            freq_12 when 15,
            '0'     when others;

	--功能:BPSK或者OOK调制区，是输出给tag前的最后一步，从此输出
	with bitout select
	    Output_cos <= 
	    	temp_output_cos_0_degree    when '0',
		    temp_output_cos_180_invert  when others;
    with bitout select
	    Output_sin <= 
	    	temp_output_sin_0_degree    when '0',
		    temp_output_sin_180_invert  when others;

end Behavioral;

---------------------------废弃代码，需要再用---------------------------------
-------2 MHz used for Barker Code dectection ----
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_unsigned.all;

--entity clk_2MHz is
--   port(clk:in std_logic;
--	     bk_clk_4MHz : out std_logic);
--end clk_2MHz;

--architecture Behavioral of clk_2MHz is
--begin
--	process(clk)
--	   variable bkclk_cnt : integer range 0 to 60;
--	   variable temp: std_logic :='0';
--	begin
--		if(rising_edge(clk)) then
--			bkclk_cnt := bkclk_cnt+1;
--			if(bkclk_cnt =  25) then
--				temp:= not temp;
--				bkclk_cnt := 0;
--			end if ;
--		end if;
--		bk_clk_4MHz <= temp;
--	end process;
--end Behavioral;


----该模块没有用到,不用考虑

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_unsigned.all;


--entity reset_clk is
--		port(
--			clk : in std_logic;
--			countnumber : in integer;
--			rst: in std_logic;
--			ctl : in std_logic;
--			chr_clk : in std_logic;
--			rst_clk : out std_logic

--		);
--end reset_clk;

--architecture Behavioral of reset_clk is
--begin
--	process(rst,ctl, clk, chr_clk, countnumber)
--	begin
--		if(rst = '1' or ctl='1') then
--			rst_clk <= '1';
--		elsif(rising_edge(clk)) then
--			   if(374 < countnumber or countnumber < 26) then
--		         rst_clk <= '1';
--		      else
--		         rst_clk <= '0';
--				end if;
--		end if;
--	end process;
--end Behavioral;

-------shift_output-----
----该模块没有用到,不用考虑
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_unsigned.all;

--entity shift_output2 is
--   port(
--	     rst: in std_logic;
--		  ctl: in std_logic;
--	     d:   in std_logic;
--		  d2 : in std_logic;
--		  freq_1:out std_logic;
--		  freq_2:out std_logic;
--		  freq_3:out std_logic;
--		  freq_:out std_logic;
--		  rst_clk : in std_logic
--		  );
--end shift_output2;

--architecture Behavioral of shift_output2 is
--begin
--   process(d, rst, ctl, rst_clk)
--		variable temp : std_logic;
--   begin
--		if(rst = '1' or ctl = '1' or rst_clk = '1') then
--			temp := '0';
--			freq_1 <= '0';
--		elsif(rising_edge(d)) then	
--			temp := not temp;
--		end if;	
--		freq_1  <= temp;
--		freq_3 <= not temp;
--	end process;
	
--	process(d2, rst, ctl, rst_clk)
--		variable temp : std_logic;
--   begin
--		if(rst = '1' or ctl = '1' or rst_clk = '1') then
--			temp := '0';
--			freq_2 <= '0';
--		elsif(rising_edge(d2)) then	
--			temp := not temp;
--		end if;	
--		freq_2  <= temp;
--		freq_ <= not temp;
--	end process;
	
--end Behavioral;