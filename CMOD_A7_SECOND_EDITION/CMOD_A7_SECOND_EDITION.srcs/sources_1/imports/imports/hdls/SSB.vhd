--本代码实现的是一块FPGA板卡控制四块块tag的功能，载波时钟与码元时钟同步的方法为动态相位
--调节频偏量的模块是："generate_16xDeltaF1","generate_16xDeltaF2","generate_16xDeltaF3","generate_16xDeltaF4"，其输出时钟为目标时钟的16倍
--发送的数据可以在"rom22"，"rom222"，"rom223"，"rom224"模块中修改
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SSB is
	
   port(  
   		  primary_clk: in std_logic;               --主晶振12MHz
		  btnC : in STD_LOGIC;			--使能tag的接收模块
		  rst :  in STD_LOGIC;			--重启tag
		  --jb1 :  in STD_LOGIC;			--比较器输出信号即前导序列#1
		  --jb2: in std_logic;            --比较器输出信号即前导序列#2
		  --jb3: in std_logic;            --比较器输出信号即前导序列#3
		  jb4: in std_logic;            --比较器输出信号即前导序列#4
		  --jc1 : out STD_LOGIC;		    --使能tag的接收模块#1
		  --jc2 : out std_logic;          --使能tag的接收模块#2
		  --jc3 : out std_logic;          --使能tag的接收模块#3
		  jc4 : out std_logic;          --使能tag的接收模块#4        
		  ld0 : out STD_LOGIC;		    --标识FPGA是否使能
		  --ld1 : out std_logic;          --标识tag#1是否接收到前导序列
		  --ld2 : out STD_LOGIC;		    --标识tag#2是否接收到前导序列
		  --ld3 : out std_logic;          --标识tag#3是否接收到前导序列
		  ld4 : out std_logic;          --标识tag#4是否接收到前导序列
	   --   output1_1: out std_logic;       --频移量cos输出#1
		  --output1_2: out std_logic;       --频移量sin输出#1
		  --output2_1: out std_logic;      --频移量cos输出#2
		  --output2_2: out std_logic;      --频移量sin输出#2
		  --output3_1: out std_logic;       --频移量cos输出#3
		  --output3_2: out std_logic;      --频移量sin输出#3
 		  output4_1: out std_logic;      --频移量cos输出#4
		  output4_2: out std_logic       --频移量sin输出#4
		  --ctrl: inout std_logic;        --以下为无用信号，接口可以用做控制MIMO第二个天线
		  --inv_ctrl: inout std_logic;
		  --ctrl2: inout std_logic;
		  --inv_ctrl2: inout std_logic;
		  --ctrl3: inout std_logic;
		  --inv_ctrl3: inout std_logic;
		  --ctrl4: inout std_logic;
		  --inv_ctrl4: inout std_logic
		  );
end SSB;


architecture Behavioral of SSB is
	signal clk : STD_LOGIC := '0';

    signal temp_output1_1: std_logic := '0';
	signal temp_output1_2: std_logic := '0';
	signal temp_output2_1: std_logic := '0';
	signal temp_output2_2: std_logic := '0';

    signal temp_output3_1: std_logic := '0';
	signal temp_output3_2: std_logic := '0';
	signal temp_output4_1: std_logic := '0';
	signal temp_output4_2: std_logic := '0';

    signal temp_output5_1: std_logic := '0';
	signal temp_output5_2: std_logic := '0';
	signal temp_output6_1: std_logic := '0';
	signal temp_output6_2: std_logic := '0';
	
	signal temp_output7_1: std_logic := '0';
	signal temp_output7_2: std_logic := '0';
	signal temp_output8_1: std_logic := '0';
	signal temp_output8_2: std_logic := '0';
	
	signal clk_oct: std_logic;
	signal bk_cck:std_logic;
	
	--tag #1
	signal clk_1:std_logic:='0';      --频移时钟
	signal enable : STD_LOGIC:='0';	  --是否使能
	--signal mclk : STD_LOGIC:='0';
	signal sig_flag : std_logic:='0'; --是否检测到目标前导序列
	signal bk_clk: std_logic:='0';    --用以采样前导序列的时钟，为1MHz（周期为4us的四分之一）
	signal ctl: std_logic:='0';       --controller模块的使能信号
	signal syn_flag: std_logic:='0';  --同步完成标识
	signal ref_clk: std_logic:='0';   --某个时钟。。不要在意
	signal addra: std_logic_vector (10 downto 0):="00000000000"; --rom中的地址
	signal data: std_logic_vector (0 downto 0):="0";             --rom数据输出，值得一提的是rom数据输出必须为vector，哪怕只有一位也是vector
	signal dataout: std_logic_vector (1 downto 0) := "00";       --卷积码数据输出
	signal bitstream: std_logic := '0';                          --二维vector的卷积码输出变为一维bit流
	signal bitsyn: std_logic := '0';                             --同步时钟，4us
	signal half_bit: std_logic := '0';                           --同步时钟的一半，8us，rom中的数据就是用这个时钟输出
	signal finish_flag : std_logic;                              --标志一次传输的完成
	signal countnumber: integer range 0 to 511;                  --同步模块的计数值
    --tag #2 信号注释同上
	signal clk_2:std_logic:='0';      
	signal enable2: STD_LOGIC:='0';	  
	--signal mclk2 : STD_LOGIC:='0';
	signal sig_flag2 : std_logic:='0';
	signal bk_clk2: std_logic:='0';
	signal ctl2: std_logic:='0';
	signal syn_flag2: std_logic:='0';
	signal ref_clk2: std_logic:='0';
	signal addra2: std_logic_vector (10 downto 0):="00000000000";
	signal data2: std_logic_vector (0 downto 0):="0";
	signal dataout2: std_logic_vector (1 downto 0) := "00";
	signal bitstream2: std_logic := '0';
	signal bitsyn2: std_logic := '0';
	signal half_bit2: std_logic := '0';
	signal finish_flag2: std_logic;
	signal countnumber2: integer range 0 to 511;
	--tag #3 信号注释同上
	signal clk_3:std_logic:='0';      --15MHz
    signal enable3 : STD_LOGIC:='0';     --working status
    signal mclk3 : STD_LOGIC:='0';
    signal sig_flag3 : std_logic:='0';
    signal bk_clk3: std_logic:='0';
    signal ctl3: std_logic:='0';
    signal syn_flag3: std_logic:='0';
    signal ref_clk3: std_logic:='0';
    signal addra3: std_logic_vector (10 downto 0):="00000000000";
    signal data3: std_logic_vector (0 downto 0):="0";
    signal dataout3: std_logic_vector (1 downto 0) := "00";
    signal bitstream3: std_logic := '0';
    signal bitsyn3: std_logic := '0';
    signal half_bit3: std_logic := '0';
    signal finish_flag3 : std_logic;
	signal countnumber3: integer range 0 to 511;
    --tag #4 信号注释同上
  	signal clk_4:std_logic:='0';      --15MHz
    signal enable4 : STD_LOGIC:='0';     --working status
    signal mclk4 : STD_LOGIC:='0';
    signal sig_flag4 : std_logic:='0';
    signal bk_clk4: std_logic:='0';
    signal ctl4: std_logic:='0';
    signal syn_flag4: std_logic:='0';
    signal ref_clk4: std_logic:='0';
    signal addra4: std_logic_vector (10 downto 0):="00000000000";
    signal data4: std_logic_vector (0 downto 0):="0";
    signal dataout4: std_logic_vector (1 downto 0) := "00";
    signal bitstream4: std_logic := '0';
    signal bitsyn4: std_logic := '0';
    signal half_bit4: std_logic := '0';
    signal finish_flag4 : std_logic;
    signal countnumber4: integer range 0 to 511;	
	--以下是相位校准模块的输入，可以先不管这个模块
	signal freq_1: std_logic;
	signal freq_2: std_logic;
	signal freq_3: std_logic;
	signal freq_4: std_logic;
	signal freq_5: std_logic;
	signal freq_6: std_logic;
	signal freq_7: std_logic;
	signal freq_8: std_logic;
	signal freq_9: std_logic;
	signal freq_10: std_logic;
	signal freq_11: std_logic;
	signal freq_12: std_logic;
	signal freq_13: std_logic;
	signal freq_14: std_logic;
	signal freq_15: std_logic;
	signal freq_16: std_logic;

	signal freq_21: std_logic;
    signal freq_22: std_logic;
    signal freq_23: std_logic;
    signal freq_24: std_logic;
    signal freq_25: std_logic;
    signal freq_26: std_logic;
    signal freq_27: std_logic;
    signal freq_28: std_logic;
    signal freq_29: std_logic;
    signal freq_210: std_logic;
    signal freq_211: std_logic;
    signal freq_212: std_logic;
    signal freq_213: std_logic;
    signal freq_214: std_logic;
    signal freq_215: std_logic;
    signal freq_216: std_logic;
    
  	signal freq_31: std_logic;
    signal freq_32: std_logic;
    signal freq_33: std_logic;
    signal freq_34: std_logic;
    signal freq_35: std_logic;
    signal freq_36: std_logic;
    signal freq_37: std_logic;
    signal freq_38: std_logic;
    signal freq_39: std_logic;
    signal freq_310: std_logic;
    signal freq_311: std_logic;
    signal freq_312: std_logic;
    signal freq_313: std_logic;
    signal freq_314: std_logic;
    signal freq_315: std_logic;
    signal freq_316: std_logic;
 	signal freq_41: std_logic;
    signal freq_42: std_logic;
    signal freq_43: std_logic;
    signal freq_44: std_logic;
    signal freq_45: std_logic;
    signal freq_46: std_logic;
    signal freq_47: std_logic;
    signal freq_48: std_logic;
    signal freq_49: std_logic;
    signal freq_410: std_logic;
    signal freq_411: std_logic;
    signal freq_412: std_logic;
    signal freq_413: std_logic;
    signal freq_414: std_logic;
    signal freq_415: std_logic;
    signal freq_416: std_logic;
    
    signal choose_result: integer range 0 to 16;	
	signal choose_result2: integer range 0 to 16;	
	signal choose_result3: integer range 0 to 16;
	signal choose_result4: integer range 0 to 16;
	
	
	
	
	signal bitout: std_logic;
	
	--signal rst_clk: std_logic := '0';
	  
  	signal bitout2: std_logic;

    --signal rst_clk2: std_logic := '0';
   
   	signal bitout3: std_logic;    
    
    
    --signal rst_clk3: std_logic := '0';
  
  	signal bitout4: std_logic;    
    
    
    --signal rst_clk4: std_logic := '0';
	component half_bitsyn
	   port(bitsyn: in std_logic;
	           rst: in std_logic;
	           ctl: in std_logic;
	            half_bit: out std_logic);
	end component;
	
	----tag #1的数据库
	--COMPONENT rom22
 --       PORT (a : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
 --           spo : OUT STD_LOGIC_VECTOR(0 DOWNTO 0));
 --   END COMPONENT;
	
	----tag #2的数据库
	--COMPONENT rom222
 --    PORT (a : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
 --        spo : OUT STD_LOGIC_VECTOR(0 DOWNTO 0));
 --   END COMPONENT;
	
 --	--tag #3的数据库
 --	COMPONENT rom223
 --   PORT (a : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
 --              spo : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
 --             );
 --   END COMPONENT;
	
	--tag #4的数据库 
	COMPONENT rom224
    PORT (a : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
              spo : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
             );
    END COMPONENT;	

	--数据库的地址选择模块
	component rom_choose
	   port(clk: in std_logic;
		    rst: in std_logic;
			ctl: in std_logic;
		    addra: out std_logic_vector(10 downto 0);
			finish_flag: inout std_logic);
	end component;
	
	component clk_1MHz
	   port(clk: in std_logic;
		     bk_clk:  out std_logic
			  );
	end component;

	--component clk_2MHz
	--   port(clk: in std_logic;
	--	     bk_cck:  out std_logic
	--		  );
	--end component;
	
	component clk_4MHz
    port(clk: in std_logic;
	     bk_cck:  out std_logic
		  );
	end component;


	component clk_0_125MHz
	   port(clk: in std_logic;
	           clk_oct: out std_logic);
	end component;
	
	--FPGA、tag接收模块的按键使能模块
	component btn_control
	   port(mclk:in std_logic;
		     rst:in std_logic;
			  enable:inout std_logic;
			  btnC:in std_logic;
			  --jc1:out std_logic;
			  --jc2:out std_logic;
			  --jc3:out std_logic;
			  jc4:out std_logic;
			  ld0:out std_logic
			  );
	end component;
	
	--巴克码检测模块
	component bk_detector
	   port(bk_clk: in std_logic;
			  rst: in std_logic;
			  ctl: in std_logic;
			  enable: in std_logic;
			  jb1: in std_logic;
			  sig_flag: inout std_logic
			  );
	end component;
	
	--同步模块，生成250KHz的OFDM码元时钟
	component synchronize
	   port(mclk: in std_logic;
		     --ctrl: inout std_logic;
			  --inv_ctrl: inout std_logic;
		     rst: in std_logic;
			  ctl: in std_logic;
		     jb1: in std_logic;
			  sig_flag: in std_logic;
		     ld2 : out std_logic;
			  syn_flag: inout std_logic;
			  bitsyn: out std_logic;
			  countnumber: out integer range 0 to 511
			  );
	end component;
	
	--重复发送模块
	component controller is
	   port(bk_clk:in std_logic;
		     syn_flag :in std_logic;
			  finish_flag :in std_logic;
		     ctl:out std_logic
			  );
	end component;
	
	--该模块将频移时钟分成16个不同相位用以相位纠正
	component shift_output is
	   port(control:in std_logic;
		     rst: in std_logic;
			  ctl: in std_logic;
		     d:in std_logic;
		     freq_1:out std_logic;
			  freq_2:out std_logic;
			  freq_3:out std_logic;
			  freq_4:out std_logic;
			  freq_5:out std_logic;
			  freq_6:out std_logic;
			  freq_7:out std_logic;
			  freq_8:out std_logic;
			  freq_9:out std_logic;
			  freq_10:out std_logic;
			  freq_11:out std_logic;
			  freq_12:out std_logic;
			  freq_13:out std_logic;
			  freq_14:out std_logic;
			  freq_15:out std_logic;
			  freq_16:out std_logic
			  );
	end component;
    
	----以下四个模块为频移时钟IP核的名称
	--component clk_15Mhz
	--   port(clk_out1: out std_logic;
	--	       clk_in1: in std_logic
	--		  );
	--end component;
	
	--component clknew2
	--     port(clk_out1: out std_logic;
	--              clk_in1: in std_logic);
	--end component;
	
	--component clknew3
	--   port(clk_out1: out std_logic;
	--           clk_in1: in std_logic);
	--end component;
	
	component clknew4
	   port(clk_out1: out std_logic;
	            clk_in1: in std_logic);
	end component;
	
	component clk_100MHz
	   port(clk_out1: out std_logic;
	            clk_in1: in std_logic);
	end component;


	--相位纠正模块，用来从16个不同相位的频移时钟中选取出一个与码元时钟最为同步的一个频移时钟的序号
	component dynamic_choose
	   port(
			  clk : in std_logic;
			  rst: in std_logic;
		      ctl: in std_logic;
		      freq_1: in std_logic;
		      freq_2: in std_logic;
			  freq_3: in std_logic;
			  freq_4: in std_logic;
			  freq_5: in std_logic;
			  freq_6: in std_logic;
			  freq_7: in std_logic;
			  freq_8: in std_logic;
			  freq_9: in std_logic;
		      freq_10: in std_logic;
			  freq_11: in std_logic;
			  freq_12: in std_logic;
			  freq_13: in std_logic;
			  freq_14: in std_logic;
			  freq_15: in std_logic;
			  freq_16: in std_logic;
			  countnumber: in integer range 0 to 511;
			  choose_result: out integer range 0 to 16
			  );
	end component;
	
	--217卷积码模块
	component con_217
	   port(
	           clk: in std_logic;
	           rst: in std_logic;
	           ctl: in std_logic;
	           datain: in std_logic_vector (0 downto 0);
	           dataout: out std_logic_vector (1 downto 0)
	           );
	end component;
	
	--将二维卷积码输出变为一维比特流
	component output
	   port(
	           clk: in std_logic;
	           rst: in std_logic;
	           ctl: in std_logic;
	           dataout: in std_logic_vector (1 downto 0);
	           bitstream: out std_logic
	           );
	 end component;
	 
	--在一位比特流之前加入8位tag-to-receiver的前导码序列用以接收机那边的星座图相位纠正
	 component manubuffer
	       port( clk: in std_logic;
					rst: in std_logic;
	                 ctl: in std_logic;
	                 bitin: in std_logic;
	                 bitout: out std_logic);
	 end component;
	   
	
begin
	generate_100MHz    : clk_100MHz    port map(clk_out1 => clk, clk_in1 => primary_clk);
    generate_1MHz      : clk_1MHz     port map(clk => clk, bk_clk => bk_clk);
    --generate_2MHz      : clk_2MHz     port map(clk => clk, bk_cck => bk_cck);
    generate_4MHz      : clk_4MHz     port map(clk => clk, bk_cck => bk_cck);
	generate_0_125MHz  : clk_0_125MHz port map(clk => bk_clk, clk_oct => clk_oct);
	--generate_16xDeltaF1: clk_15Mhz    port map(clk_out1 => clk_1, clk_in1 => clk);
	--generate_16xDeltaF2: clknew2      port map(clk_out1 => clk_2, clk_in1 => clk);
	--generate_16xDeltaF3: clknew3      port map(clk_out1 => clk_3, clk_in1 => clk);
	generate_16xDeltaF4: clknew4      port map(clk_out1 => clk_4, clk_in1 => clk);

	--generate_half : half_bitsyn port map (bitsyn => bitsyn,  rst => rst, ctl => ctl,  half_bit => half_bit);
	--generate_half2: half_bitsyn port map (bitsyn => bitsyn2, rst => rst, ctl => ctl2, half_bit => half_bit2);
	--generate_half3: half_bitsyn port map (bitsyn => bitsyn3, rst => rst, ctl => ctl3, half_bit => half_bit3);
	generate_half4: half_bitsyn port map (bitsyn => bitsyn4, rst => rst, ctl => ctl4, half_bit => half_bit4);
	
	--u10:rom22          port map(a => addra,  spo => data);
	--u20:rom222         port map(a => addra2, spo => data2);
	--u30:rom223         port map(a => addra3, spo => data3);
	u40:rom224         port map(a => addra4, spo => data4);
	
	--u11:rom_choose     port map(clk     => half_bit, rst => rst,     ctl => ctl,  addra => addra,  finish_flag => finish_flag);
	--u21:rom_choose     port map(clk     => half_bit2, rst => rst,     ctl => ctl2,  addra => addra2,  finish_flag => finish_flag2);
	--u31:rom_choose     port map(clk     => half_bit3, rst => rst,     ctl => ctl3,  addra => addra3,  finish_flag => finish_flag3);
	u41:rom_choose     port map(clk     => half_bit4, rst => rst,     ctl => ctl4,  addra => addra4,  finish_flag => finish_flag4);
	
	u12:btn_control    port map(mclk    => clk,     rst => rst,     enable => enable, btnC => btnC, jc4 => jc4, ld0 => ld0);
	
	--u13:controller     port map(bk_clk  => clk_oct, syn_flag    => syn_flag,  finish_flag => finish_flag,  ctl => ctl);
	--u23:controller     port map(bk_clk  => clk_oct, syn_flag    => syn_flag2,  finish_flag => finish_flag2,  ctl => ctl2);
	--u33:controller     port map(bk_clk  => clk_oct, syn_flag    => syn_flag3,  finish_flag => finish_flag3,  ctl => ctl3);
	u43:controller     port map(bk_clk  => clk_oct, syn_flag    => syn_flag4,  finish_flag => finish_flag4,  ctl => ctl4);

	--u14:bk_detector    port map(bk_clk  => bk_cck, rst=> rst,      ctl      => ctl,      enable   => enable,  jb1     => jb1,    sig_flag    => sig_flag);
	--u24:bk_detector    port map(bk_clk  => bk_cck, rst=> rst,      ctl      => ctl2,      enable   => enable,  jb1     => jb2,    sig_flag    => sig_flag2);	                                                   
	--u34:bk_detector    port map(bk_clk  => bk_cck, rst=> rst,      ctl      => ctl3,      enable   => enable,  jb1     => jb3,    sig_flag    => sig_flag3);	
	u44:bk_detector    port map(bk_clk  => bk_cck, rst=> rst,      ctl      => ctl4,      enable   => enable,  jb1     => jb4,    sig_flag    => sig_flag4);	
	
	--u15:synchronize    port map(mclk => clk,    rst     => rst,      ctl     => ctl,  jb1     => jb1,    sig_flag  => sig_flag,  ld2 => ld1, syn_flag => syn_flag, bitsyn  => bitsyn, countnumber => countnumber);
	--u25:synchronize    port map(mclk => clk,    rst     => rst,      ctl     => ctl2,  jb1     => jb2,    sig_flag  => sig_flag2,  ld2 => ld2, syn_flag => syn_flag2, bitsyn  => bitsyn2, countnumber => countnumber2);
	--u35:synchronize    port map(mclk => clk,    rst     => rst,      ctl     => ctl3,  jb1     => jb3,    sig_flag  => sig_flag3,  ld2 => ld3, syn_flag => syn_flag3, bitsyn  => bitsyn3, countnumber => countnumber3);
	u45:synchronize    port map(mclk => clk,  rst     => rst,   ctl     => ctl4,  jb1     => jb4,    sig_flag  => sig_flag4,  ld2 => ld4, syn_flag => syn_flag4, bitsyn  => bitsyn4, countnumber => countnumber4);

	--u16:shift_output   port map(control => syn_flag,   rst => rst,  ctl => ctl,  d => clk_1, 
	--                            freq_1  => freq_1,  freq_2  => freq_2,  freq_3  => freq_3,  freq_4  => freq_4,  
	--							freq_5  => freq_5,  freq_6  => freq_6,  freq_7  => freq_7,  freq_8  => freq_8,
	--                            freq_9  => freq_9,  freq_10 => freq_10, freq_11 => freq_11, freq_12 => freq_12,
 --                               freq_13 => freq_13, freq_14 => freq_14, freq_15 => freq_15, freq_16 => freq_16);	
 --	u26:shift_output   port map(control => syn_flag2,rst     => rst,     ctl     => ctl2,     d       => clk_2, 
 --                               freq_1  => freq_21,  freq_2  => freq_22,  freq_3  => freq_23,  freq_4  => freq_24,  
 --                               freq_5  => freq_25,  freq_6  => freq_26,  freq_7  => freq_27,  freq_8  => freq_28,
 --                               freq_9  => freq_29,  freq_10 => freq_210, freq_11 => freq_211, freq_12 => freq_212,
 --                               freq_13 => freq_213, freq_14 => freq_214, freq_15 => freq_215, freq_16 => freq_216);    
 --	u36:shift_output   port map(control => syn_flag3,rst     => rst,     ctl     => ctl3,     d       => clk_3, 
 --                               freq_1  => freq_31,  freq_2  => freq_32,  freq_3  => freq_33,  freq_4  => freq_34,  
 --                               freq_5  => freq_35,  freq_6  => freq_36,  freq_7  => freq_37,  freq_8  => freq_38,
 --                               freq_9  => freq_39,  freq_10 => freq_310, freq_11 => freq_311, freq_12 => freq_312,
 --                               freq_13 => freq_313, freq_14 => freq_314, freq_15 => freq_315, freq_16 => freq_316);    
	u46:shift_output   port map(control => syn_flag4,rst     => rst,     ctl     => ctl4,     d       => clk_4, 
                                freq_1  => freq_41,  freq_2  => freq_42,  freq_3  => freq_43,  freq_4  => freq_44,  
                                freq_5  => freq_45,  freq_6  => freq_46,  freq_7  => freq_47,  freq_8  => freq_48,
                                freq_9  => freq_49,  freq_10 => freq_410, freq_11 => freq_411, freq_12 => freq_412,
                                freq_13 => freq_413, freq_14 => freq_414, freq_15 => freq_415, freq_16 => freq_416); 
								
    --u18: manubuffer port map (clk => bitsyn,  rst => rst, ctl => ctl,  bitin => bitstream,  bitout => bitout);
    --u28: manubuffer port map (clk => bitsyn2, rst => rst, ctl => ctl2, bitin => bitstream2, bitout => bitout2);
    --u38: manubuffer port map (clk => bitsyn3, rst => rst, ctl => ctl3, bitin => bitstream3, bitout => bitout3);
    u48: manubuffer port map (clk => bitsyn4, rst => rst, ctl => ctl4, bitin => bitstream4, bitout => bitout4);


	--u17:dynamic_choose port map(clk     => bitsyn,  rst     => rst,     ctl     => ctl, 
	--                            freq_1  => freq_1,  freq_2  => freq_2,  freq_3  => freq_3,  freq_4  => freq_4, 
	--							freq_5  => freq_5,  freq_6  => freq_6,  freq_7  => freq_7,  freq_8  => freq_8, 
	--							freq_9  => freq_9,  freq_10 => freq_10, freq_11 => freq_11, freq_12 => freq_12,
 --                               freq_13 => freq_13, freq_14 => freq_14, freq_15 => freq_15, freq_16 => freq_16, 
	--						    countnumber => countnumber, choose_result => choose_result);	
	--u27:dynamic_choose port map(clk     => bitsyn2,  rst     => rst,     ctl     => ctl2, 
 --                               freq_1  => freq_21,  freq_2  => freq_22,  freq_3  => freq_23,  freq_4  => freq_24, 
 --                               freq_5  => freq_25,  freq_6  => freq_26,  freq_7  => freq_27,  freq_8  => freq_28, 
 --                               freq_9  => freq_29,  freq_10 => freq_210, freq_11 => freq_211, freq_12 => freq_212,
 --                               freq_13 => freq_213, freq_14 => freq_214, freq_15 => freq_215, freq_16 => freq_216, 
 --                               countnumber => countnumber2, choose_result => choose_result2);    
	--u37:dynamic_choose port map(clk     => bitsyn3,  rst     => rst,     ctl     => ctl3, 
 --                               freq_1  => freq_31,  freq_2  => freq_32,  freq_3  => freq_33,  freq_4  => freq_34, 
 --                               freq_5  => freq_35,  freq_6  => freq_36,  freq_7  => freq_37,  freq_8  => freq_38, 
 --                               freq_9  => freq_39,  freq_10 => freq_310, freq_11 => freq_311, freq_12 => freq_312,
 --                               freq_13 => freq_313, freq_14 => freq_314, freq_15 => freq_315, freq_16 => freq_316, 
 --                               countnumber => countnumber3, choose_result => choose_result3);    
	u47:dynamic_choose port map(clk     => bitsyn4,  rst     => rst,     ctl     => ctl4, 
                                freq_1  => freq_41,  freq_2  => freq_42,  freq_3  => freq_43,  freq_4  => freq_44, 
                                freq_5  => freq_45,  freq_6  => freq_46,  freq_7  => freq_47,  freq_8  => freq_48, 
                                freq_9  => freq_49,  freq_10 => freq_410, freq_11 => freq_411, freq_12 => freq_412,
                                freq_13 => freq_413, freq_14 => freq_414, freq_15 => freq_415, freq_16 => freq_416, 
                                countnumber => countnumber4, choose_result => choose_result4);  

								
	--u70: con_217 port map (clk => half_bit, rst => rst, ctl => ctl, datain => data, dataout => dataout);
 --   u71: output port map (clk => bitsyn, rst => rst, ctl => ctl, dataout => dataout, bitstream => bitstream);	 
	--u270: con_217 port map (clk => half_bit2, rst => rst, ctl => ctl2, datain => data2, dataout => dataout2);
 --   u271: output port map (clk => bitsyn2, rst => rst, ctl => ctl2, dataout => dataout2, bitstream => bitstream2);    
	--u370: con_217 port map (clk => half_bit3, rst => rst, ctl => ctl3, datain => data3, dataout => dataout3);
 --   u371: output port map (clk => bitsyn3, rst => rst, ctl => ctl3, dataout => dataout3, bitstream => bitstream3);    
	u470: con_217 port map (clk => half_bit4, rst => rst, ctl => ctl4, datain => data4, dataout => dataout4);
    u471: output port map (clk => bitsyn4, rst => rst, ctl => ctl4, dataout => dataout4, bitstream => bitstream4);    
	
	--对应dynamicchoose模块输出的数字，从十六个频移时钟选出一个
	--with choose_result select	   
	--	temp_output1_1 <= freq_1  when 0,
	--	                              freq_2  when 1,
	--							      freq_3  when 2,
	--							freq_4  when 3,
	--							freq_5  when 4,
	--							freq_6  when 5,
	--							freq_7  when 6,
	--							freq_8  when 7,
	--							freq_9  when 8,
	--							freq_10 when 9,
	--	                  freq_11 when 10,
	--							freq_12 when 11,
	--							freq_13 when 12,
	--							freq_14 when 13,
	--							freq_15 when 14,
	--							freq_16 when 15,
	--							'0'     when others;
								
	--with choose_result select	   
	--	temp_output1_2 <= freq_5  when 0,
	--	                  freq_6  when 1,
	--							freq_7  when 2,
	--							freq_8  when 3,
	--							freq_9  when 4,
	--							freq_10 when 5,
	--							freq_11 when 6,
	--							freq_12 when 7,
	--							freq_13 when 8,
	--							freq_14 when 9,
	--	                  freq_15 when 10,
	--							freq_16 when 11,
	--							freq_1  when 12,
	--							freq_2  when 13,
	--							freq_3  when 14,
	--							freq_4  when 15,
	--							'0'     when others;
	--with choose_result select	   
	--	temp_output2_1 <= freq_9  when 0,
	--	                  freq_10 when 1,
	--							freq_11 when 2,
	--							freq_12 when 3,
	--							freq_13 when 4,
	--							freq_14 when 5,
	--							freq_15 when 6,
	--							freq_16 when 7,
	--							freq_1  when 8,
	--							freq_2  when 9,
	--	                  freq_3  when 10,
	--							freq_4  when 11,
	--							freq_5  when 12,
	--							freq_6  when 13,
	--							freq_7  when 14,
	--							freq_8  when 15,
	--							'0'     when others;
								
	--with choose_result select	   
	--	temp_output2_2 <= freq_13 when 0,
	--	                  freq_14 when 1,
	--							freq_15 when 2,
	--							freq_16 when 3,
	--							freq_1  when 4,
	--							freq_2  when 5,
	--							freq_3  when 6,
	--							freq_4  when 7,
	--							freq_5  when 8,
	--							freq_6  when 9,
	--	                  freq_7  when 10,
	--							freq_8  when 11,
	--							freq_9  when 12,
	--							freq_10 when 13,
	--							freq_11 when 14,
	--							freq_12 when 15,
	--							'0'     when others;

	--	with choose_result2 select	   
	--	temp_output3_1 <= freq_21  when 0,
	--	                  freq_22  when 1,
	--							freq_23  when 2,
	--							freq_24  when 3,
	--							freq_25  when 4,
	--							freq_26  when 5,
	--							freq_27  when 6,
	--							freq_28  when 7,
	--							freq_29  when 8,
	--							freq_210 when 9,
	--	                  freq_211 when 10,
	--							freq_212 when 11,
	--							freq_213 when 12,
	--							freq_214 when 13,
	--							freq_215 when 14,
	--							freq_216 when 15,
	--							'0'     when others;
								
	--with choose_result2 select	   
	--	temp_output3_2 <= freq_25  when 0,
	--	                  freq_26  when 1,
	--							freq_27  when 2,
	--							freq_28  when 3,
	--							freq_29  when 4,
	--							freq_210 when 5,
	--							freq_211 when 6,
	--							freq_212 when 7,
	--							freq_213 when 8,
	--							freq_214 when 9,
	--	                  freq_215 when 10,
	--							freq_216 when 11,
	--							freq_21  when 12,
	--							freq_22  when 13,
	--							freq_23  when 14,
	--							freq_24  when 15,
	--							'0'     when others;
	--with choose_result2 select	   
	--	temp_output4_1 <= freq_29  when 0,
	--	                  freq_210 when 1,
	--							freq_211 when 2,
	--							freq_212 when 3,
	--							freq_213 when 4,
	--							freq_214 when 5,
	--							freq_215 when 6,
	--							freq_216 when 7,
	--							freq_21  when 8,
	--							freq_22  when 9,
	--	                  freq_23  when 10,
	--							freq_24  when 11,
	--							freq_25  when 12,
	--							freq_26  when 13,
	--							freq_27  when 14,
	--							freq_28  when 15,
	--							'0'     when others;
								
	--with choose_result2 select	   
	--	temp_output4_2 <= freq_213 when 0,
	--	                  freq_214 when 1,
	--							freq_215 when 2,
	--							freq_216 when 3,
	--							freq_21  when 4,
	--							freq_22  when 5,
	--							freq_23  when 6,
	--							freq_24  when 7,
	--							freq_25  when 8,
	--							freq_26  when 9,
	--	                  freq_27  when 10,
	--							freq_28  when 11,
	--							freq_29  when 12,
	--							freq_210 when 13,
	--							freq_211 when 14,
	--							freq_212 when 15,
	--							'0'     when others;

	--	with choose_result3 select	   
	--	temp_output5_1 <= freq_31  when 0,
	--	                  freq_32  when 1,
	--							freq_33  when 2,
	--							freq_34  when 3,
	--							freq_35  when 4,
	--							freq_36  when 5,
	--							freq_37  when 6,
	--							freq_38  when 7,
	--							freq_39  when 8,
	--							freq_310 when 9,
	--	                  freq_311 when 10,
	--							freq_312 when 11,
	--							freq_313 when 12,
	--							freq_314 when 13,
	--							freq_315 when 14,
	--							freq_316 when 15,
	--							'0'     when others;
								
	--with choose_result3 select	   
	--	temp_output5_2 <= freq_35  when 0,
	--	                  freq_36  when 1,
	--							freq_37  when 2,
	--							freq_38  when 3,
	--							freq_39  when 4,
	--							freq_310 when 5,
	--							freq_311 when 6,
	--							freq_312 when 7,
	--							freq_313 when 8,
	--							freq_314 when 9,
	--	                  freq_315 when 10,
	--							freq_316 when 11,
	--							freq_31  when 12,
	--							freq_32  when 13,
	--							freq_33  when 14,
	--							freq_34  when 15,
	--							'0'     when others;
	--with choose_result3 select	   
	--	temp_output6_1 <= freq_39  when 0,
	--	                  freq_310 when 1,
	--							freq_311 when 2,
	--							freq_312 when 3,
	--							freq_313 when 4,
	--							freq_314 when 5,
	--							freq_315 when 6,
	--							freq_316 when 7,
	--							freq_31  when 8,
	--							freq_32  when 9,
	--	                  freq_33  when 10,
	--							freq_34  when 11,
	--							freq_35  when 12,
	--							freq_36  when 13,
	--							freq_37  when 14,
	--							freq_38  when 15,
	--							'0'     when others;
								
	--with choose_result3 select	   
	--	temp_output6_2 <= freq_313 when 0,
	--	                  freq_314 when 1,
	--							freq_315 when 2,
	--							freq_316 when 3,
	--							freq_31  when 4,
	--							freq_32  when 5,
	--							freq_33  when 6,
	--							freq_34  when 7,
	--							freq_35  when 8,
	--							freq_36  when 9,
	--	                  freq_37  when 10,
	--							freq_38  when 11,
	--							freq_39  when 12,
	--							freq_310 when 13,
	--							freq_311 when 14,
	--							freq_312 when 15,
	--							'0'     when others;
								
		with choose_result4 select	   
                                temp_output7_1 <=       freq_41  when 0,
                                                    	freq_42  when 1,
                                                        freq_43  when 2,
                                                        freq_44  when 3,
                                                        freq_45  when 4,
                                                        freq_46  when 5,
                                                        freq_47  when 6,
                                                        freq_48  when 7,
                                                        freq_49  when 8,
                                                        freq_410 when 9,
                                                        freq_411 when 10,
                                                        freq_412 when 11,
                                                        freq_413 when 12,
                                                        freq_414 when 13,
                                                        freq_415 when 14,
                                                        freq_416 when 15,
                                                        '0'     when others;
                                                        
                            with choose_result4 select       
                                temp_output7_2 <= 		freq_45  when 0,
                                                        freq_46  when 1,
                                                        freq_47  when 2,
                                                        freq_48  when 3,
                                                        freq_49  when 4,
                                                        freq_410 when 5,
                                                        freq_411 when 6,
                                                        freq_412 when 7,
                                                        freq_413 when 8,
                                                        freq_414 when 9,
                                                        freq_415 when 10,
                                                        freq_416 when 11,
                                                        freq_41  when 12,
                                                        freq_42  when 13,
                                                        freq_43  when 14,
                                                        freq_44  when 15,
                                                        '0'     when others;
                            with choose_result4 select       
                                temp_output8_1 <= 		freq_49  when 0,
                                                        freq_410 when 1,
                                                        freq_411 when 2,
                                                        freq_412 when 3,
                                                        freq_413 when 4,
                                                        freq_414 when 5,
                                                        freq_415 when 6,
                                                        freq_416 when 7,
                                                        freq_41  when 8,
                                                        freq_42  when 9,
                                                        freq_43  when 10,
                                                        freq_44  when 11,
                                                        freq_45  when 12,
                                                        freq_46  when 13,
                                                        freq_47  when 14,
                                                        freq_48  when 15,
                                                        '0'     when others;
                                                        
                            with choose_result4 select       
                                temp_output8_2 <= 		freq_413 when 0,
                                                        freq_414 when 1,
                                                        freq_415 when 2,
                                                        freq_416 when 3,
                                                        freq_41  when 4,
                                                        freq_42  when 5,
                                                        freq_43  when 6,
                                                        freq_44  when 7,
                                                        freq_45  when 8,
                                                        freq_46  when 9,
                                                        freq_47  when 10,
                                                        freq_48  when 11,
                                                        freq_49  when 12,
                                                        freq_410 when 13,
                                                        freq_411 when 14,
                                                        freq_412 when 15,
                                                        '0'     when others;
														
	--以下即为调制模块

	--with bitout select
	--   output1_1 <= temp_output1_1 when '0',
	--	             temp_output2_1 when others;
	--with bitout select
	--   output1_2 <= temp_output1_2 when '0',
	--	             temp_output2_2 when others;
	--with bitout2 select
	--   output2_1 <= temp_output3_1 when '0',
	--	             temp_output4_1 when others;
	--with bitout2 select
	--   output2_2 <= temp_output3_2 when '0',
	--	             temp_output4_2 when others;
	--with bitout3 select
	--   output3_1 <= temp_output5_1 when '0',
	--	                   temp_output6_1 when others;
	--with bitout3 select
	--   output3_2 <= temp_output5_2 when '0',
	--	                    temp_output6_2 when others;
	with bitout4 select
	   output4_1 <= temp_output7_1 when '0',
		                   temp_output8_1 when others;
   with bitout4 select
	   output4_2 <= temp_output7_2 when '0',
		                    temp_output8_2 when others;

end Behavioral;
	


-----1 MHz used for Barker Code dectection ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity clk_1MHz is
   port(clk:in std_logic;
	     bk_clk:out std_logic);
end clk_1MHz;

architecture Behavioral of clk_1MHz is
begin
	process(clk)
	   variable bkclk_cnt : integer range 0 to 60;
	   variable temp: std_logic :='0';
	begin
		if(rising_edge(clk)) then
			bkclk_cnt := bkclk_cnt+1;
			if(bkclk_cnt =  50) then
				temp:= not temp;
				bkclk_cnt := 0;
			end if ;
		end if;
		bk_clk <= temp;
	end process;
end Behavioral;


-------2 MHz used for Barker Code dectection ----
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_unsigned.all;

--entity clk_2MHz is
--   port(clk:in std_logic;
--	     bk_cck : out std_logic);
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
--		bk_cck <= temp;
--	end process;
--end Behavioral;

-----4 MHz used for Barker Code dectection ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity clk_4MHz is
   port(clk:in std_logic;
	     bk_cck : out std_logic);
end clk_4MHz;

architecture Behavioral of clk_4MHz is
begin
	process(clk)
	   variable bkclk_cnt : integer range 0 to 60;
	   variable temp: std_logic :='0';
	begin
		if(rising_edge(clk)) then
			bkclk_cnt := bkclk_cnt+1;
			if(bkclk_cnt =  25) then
				temp:= not temp;
				bkclk_cnt := 0;
			end if ;
		end if;
		if(falling_edge(clk)) then
			bkclk_cnt := bkclk_cnt+1;
			if(bkclk_cnt =  25) then
				temp:= not temp;
				bkclk_cnt := 0;
			end if ;
		end if;
		bk_cck <= temp;
	end process;
end Behavioral;


-----0.125 MHz used for Barker Code dectection ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity clk_0_125MHz is
   port(clk:in std_logic;
	        clk_oct: out std_logic);
end clk_0_125MHz;

architecture Behavioral of clk_0_125MHz is
begin
	process(clk)
	   variable cnt : integer range 0 to 7;
	   variable temp: std_logic :='0';
	begin
		if(rising_edge(clk)) then
			cnt := cnt+1;
			if(cnt =  2) then
				temp:= not temp;
				cnt := 0;
			end if ;
		end if;
		clk_oct <= temp;
	end process;
end Behavioral;

----- halfen the bitsyn ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity half_bitsyn is
   port(bitsyn:in std_logic;
            rst: in std_logic;
            ctl: in std_logic;
	        half_bit: out std_logic);
end half_bitsyn;

architecture Behavioral of half_bitsyn is
begin
	process(bitsyn, ctl, rst)
	   variable cnt : integer range 0 to 7;
	   variable temp: std_logic :='0';
	begin
	    if(rst = '1' or ctl = '1') then
	       temp := '0';
		elsif(rising_edge(bitsyn)) then
			cnt := cnt+1;
			if(cnt =  1) then
				temp:= not temp;
				cnt := 0;
			end if ;
		end if;
		half_bit <= temp;
	end process;
end Behavioral;


--shift_output
--这里采用的是延迟计数的方式得到16个不同相位的的频移时钟
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity shift_output is
   port(control:in std_logic;
	     rst: in std_logic;
		  ctl: in std_logic;
	     d:in std_logic;
		  freq_1:out std_logic;
		  freq_2:out std_logic;
		  freq_3:out std_logic;
		  freq_4:out std_logic;
		  freq_5:out std_logic;
		  freq_6:out std_logic;
		  freq_7:out std_logic;
		  freq_8:out std_logic;
		  freq_9:out std_logic;
		  freq_10:out std_logic;
		  freq_11:out std_logic;
		  freq_12:out std_logic;
		  freq_13:out std_logic;
		  freq_14:out std_logic;
		  freq_15:out std_logic;
		  freq_16:out std_logic);
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
		freq_1 <= '0';
		freq_2 <= '0';
		freq_3 <= '0';
		freq_4 <= '0';
		freq_5 <= '0';
		freq_6 <= '0';
		freq_7 <= '0';
		freq_8 <= '0';
		freq_1 <= '0';
		freq_9 <= '0';
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

--该模块没有用到，不用考虑

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity reset_clk is
		port(
			clk : in std_logic;
			countnumber : in integer;
			rst: in std_logic;
			ctl : in std_logic;
			chr_clk : in std_logic;
			rst_clk : out std_logic

		);
end reset_clk;

architecture Behavioral of reset_clk is
begin
	process(rst,ctl, clk, chr_clk, countnumber)
	begin
		if(rst = '1' or ctl='1') then
			rst_clk <= '1';
		elsif(rising_edge(clk)) then
			   if(374 < countnumber or countnumber < 26) then
		         rst_clk <= '1';
		      else
		         rst_clk <= '0';
				end if;
		end if;
	end process;
end Behavioral;

-----shift_output-----
--该模块没有用到，不用考虑
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity shift_output2 is
   port(
	     rst: in std_logic;
		  ctl: in std_logic;
	     d:   in std_logic;
		  d2 : in std_logic;
		  freq_1:out std_logic;
		  freq_2:out std_logic;
		  freq_3:out std_logic;
		  freq_4:out std_logic;
		  rst_clk : in std_logic
		  );
end shift_output2;

architecture Behavioral of shift_output2 is
begin
   process(d, rst, ctl, rst_clk)
		variable temp : std_logic;
   begin
		if(rst = '1' or ctl = '1' or rst_clk = '1') then
			temp := '0';
			freq_1 <= '0';
		elsif(rising_edge(d)) then	
			temp := not temp;
		end if;	
		freq_1  <= temp;
		freq_3 <= not temp;
	end process;
	
	process(d2, rst, ctl, rst_clk)
		variable temp : std_logic;
   begin
		if(rst = '1' or ctl = '1' or rst_clk = '1') then
			temp := '0';
			freq_2 <= '0';
		elsif(rising_edge(d2)) then	
			temp := not temp;
		end if;	
		freq_2  <= temp;
		freq_4 <= not temp;
	end process;
	
end Behavioral;


------ (2, 1, 7) convolution code -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity con_217 is
   port(
           rst: in std_logic;
           ctl: in std_logic;
           clk: in std_logic;
           datain:in std_logic_vector (0 downto 0);
	       dataout:out std_logic_vector (1 downto 0));
end con_217;

architecture Behavioral of con_217 is
    --signal reg: std_logic_vector (6 downto 0) := "0000000";
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

------ output carrier -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity output is
    port (clk: in std_logic;
             rst: in std_logic;
             ctl: in std_logic;
             dataout: in std_logic_vector (1 downto 0);
             bitstream: out std_logic
             );
end output;

architecture Behavioral of output is
    --signal cnt: integer range 0 to 3 := 0;
begin
	process (rst, ctl, clk, dataout(1), dataout(0))
        variable cnt: integer range 0 to 3 := 0;
        variable temp: std_logic;
	begin
	       if (rst = '1' or ctl = '1') then
	           cnt := 0;
	       elsif (clk'event and clk = '1') then
	           if (cnt = 1) then
	               cnt := 0;
	               if (dataout(1) = '0') then
	                   temp := '0';
	               elsif (dataout(1) = '1') then
	                   temp := '1';
	               end if;
	           elsif (cnt = 0) then
	               cnt := cnt + 1;
	               if (dataout(0) = '0') then
	                   temp := '0';
                   elsif (dataout(0) = '1') then
                       temp := '1';
                   end if;
                end if;	           
	       end if;
	    bitstream <= temp;
	end process;
end Behavioral;

-----------buffer ----------
--在一位比特流之前加入8位tag-to-receiver的前导码序列用以接收机那边的星座图相位纠正
--思路是增加一个vector作为一个FIFO的容器，容器里面事先存好to_rx的前导码序列
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity manubuffer is
    port(clk: in std_logic;
             rst: in std_logic;
             ctl: in std_logic;
             bitin: in std_logic;
             bitout: out std_logic);
end manubuffer;

architecture Behavorial of manubuffer is
--    signal vector: std_logic_vector (7 downto 0);
begin
    process(clk, rst, ctl)
        variable vector: std_logic_vector (5 downto 0);
    begin
        if(rst = '1' or ctl = '1') then
            vector := "110000";
        elsif (clk'event and clk = '1') then
            bitout <= vector(5);
            vector(5)  := vector(4);
            vector(4)  := vector(3);
            vector(3)  := vector(2);
            vector(2)  := vector(1);
            vector(1)  := vector(0);
            if (bitin = '1' or bitin = '0') then
                vector(0)  := bitin;
            else
                vector(0) := '1';
            end if;
        end if;
    end process;
end Behavorial;