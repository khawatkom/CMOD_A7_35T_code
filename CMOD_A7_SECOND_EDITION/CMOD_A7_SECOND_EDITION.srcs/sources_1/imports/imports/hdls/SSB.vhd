-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--������ʵ�ֵ���һ��С��FPGA�忨����һ��tag�Ĺ���,�ز�ʱ������Ԫʱ��ͬ���ķ���Ϊ��̬��λ
--����Ƶƫ����ģ����:"generate_16xDeltaF",�����ʱ��ΪĿ��ʱ�ӵ�16��
--���͵����ݿ�����"rom224"ģ�����޸�
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity SSB is
    port(  
		primary_clk                : in 	std_logic;              --������12MHz
		btn_enable_tag_Rx          : in 	STD_LOGIC;			    --ʹ��tag�Ľ���ģ��
		rst                        : in 	STD_LOGIC;			    --����tag
		Input_from_Tag             : in 	std_logic;              --�Ƚ�������źż�ǰ������
		Enable_to_Tag              : out 	std_logic;              --ʹ��tag�Ľ���ģ��        
		LED_flag_of_FPGA_start     : out 	STD_LOGIC;		        --��ʶFPGA�Ƿ�ʹ��
		LED_flag_of_TiggerSequence : out 	std_logic;              --��ʶtag#4�Ƿ���յ�ǰ������
		Output_cos                 : out 	std_logic;              --Ƶ����cos���
		Output_sin                 : out 	std_logic;              --Ƶ����sin���
		ctrl                       : inout  std_logic;              --����Tag�Ľ������������Ķ�ѡһ����,ѡ��������һ��·
        inv_ctrl                   : inout  std_logic               --��ctrl�෴,���߽��ʹ��,ͬһ����
		);
end SSB;


architecture Behavioral of SSB is
	
--------------------------------------------����������---------------------------------------
---------------------------------------------------------------------------------------------	
	signal clk : STD_LOGIC := '0';
	
	signal temp_output_cos_0_degree:   std_logic := '0';
	signal temp_output_sin_0_degree:   std_logic := '0';
	signal temp_output_cos_180_invert: std_logic := '0';
	signal temp_output_sin_180_invert: std_logic := '0';
	
	signal clk_8us : std_logic;          --controllerʱ��,0.125MHz,���ڴ���bit����,���Կ����Ժ���ߵ�0.25MHz
	signal bk_clk_4MHz  : std_logic;          --�Ϳ���ʱ��,4MHz,����44λ��Ƶ
	
	--tag ��Ҫ�ı���
	signal clk_1       : std_logic:='0';      --Ƶ��ʱ��
	signal enable      : std_logic:='0';	  --�Ƿ�ʹ��
	signal sig_flag    : std_logic:='0';      --�Ƿ��⵽Ŀ��ǰ������
	signal bk_clk      : std_logic:='0';      --���Բ���ǰ�����е�ʱ��,Ϊ1MHz������Ϊ4us���ķ�֮һ��
	signal ctl         : std_logic:='0';      --controllerģ���ʹ���ź�
	signal syn_start_flag    : std_logic:='0';      --ͬ����ɱ�ʶ
	signal addra       : std_logic_vector (10 downto 0):="00000000000";  --rom�еĵ�ַ
	signal data        : std_logic_vector (0 downto 0):="0";             --rom�������,ֵ��һ�����rom�����������Ϊvector,����ֻ��һλҲ��vector
	signal dataout     : std_logic_vector (1 downto 0) := "00";          --������������
	signal bitstream   : std_logic := '0';                               --��άvector�ľ���������Ϊһάbit��
	signal syn_clk_4us      : std_logic := '0';                               --ͬ��ʱ��,4us
	signal rom_output_clk_8us    : std_logic := '0';                               --ͬ��ʱ�ӵ�һ��,8us,rom�е����ݾ��������ʱ�����
	signal finish_flag : std_logic;                                      --��־һ�δ�������,490+֮ǰ�ļ�λ��
	signal countnumber : integer range 0 to 511;                         --ͬ��ģ��ļ���ֵ

	--��������λУ׼ģ�������,��2pi����16��,Ȼ��ѡ������һ����λ��ӽ��ġ�
	--������д������,�Ժ�Ӧ���޸�,ʹ�ñ�׼��DPL�������໷
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
	signal choose_result_of_16freq : integer range 0 to 16; --ѡ��16����λ�е���һ����Ϊͬ����λ

  	signal bitout : std_logic; --FPGAҪ����ı�����,����rom���ߴ������ռ�,nλ+490 



-------------------------------------------------------------------------------------------------------------
------------------------------------------COMPONENT������-----------------------------------------------------
-------------------------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------
	--------------------------------------����ʱ������ģ��---------------------------------------
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

	--IP������OFDMƵƫ��Ƶʱ��,��Χ��100~500MHz֮��
	component clknew4
	    port(
			clk_out1 : out std_logic;
			clk_in1  : in  std_logic
            );
	end component;
	
	--IP������100MHz��Ƶʱ��
	component clk_100MHz
	    port( 
			clk_out1 : out std_logic;
			clk_in1  : in  std_logic
			);
	end component;

  	--����ͬ��ʱ�ӵ�һ��,8us
  	--����:rom�е����ݾ��������ʱ�����,syn_clk_4usΪͬ��ʱ��,4us,rom_output_clk_8usΪ���ʱ��,8us
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
	--------------------------------------���ݿ�IP��ʹ�����ģ��---------------------------------
	--���ݿ�ĵ�ַѡ��ģ��
	--����:clkΪ8us��rom_output_clk_8usʱ��,ÿһ��clk��������ʱaddra��һ,���addr�ǵ�һ����ֵ,
	--��˵��һ�����ݴ������,��ʱfinish_flag��1,֪ͨcontrollerģ�鿪ʼ��������ģ��,�Զ�������һ�δ���
	component rom_choose
	    port(
			clk         : in    std_logic;
			rst         : in    std_logic;
			ctl         : in    std_logic;
			addra       : out   std_logic_vector(10 downto 0);
			finish_flag : inout std_logic
			);
	end component;
	
  	--tag�����ݿ�
  	--����:aΪ���������,��Ϊȡ���ݵĵ�ַ,��a��ַȡ��1λ����spo�������޸�λ����
	COMPONENT rom224
		PORT(
			a   : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
			spo : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
			);
	END COMPONENT;
	-------------------------------------------------------------------------------------------


	-------------------------------------------------------------------------------------------
    --FPGA��tag����ģ��İ���ʹ��ģ��
    --����:ʹ��ʱ��Ϊ������,100MHz,����btn_enable_tag_Rxʹ��FPGA,
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
	
    --�Ϳ�����ģ��,
    --����:���ɹ������sig_flagΪ1,ʹ��rst����ctl����, Ҫ��enableΪ1,��tag�Ľ���ģ�����ڳ��Խ��մ�������
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
	
	--ͬ��ģ��,����250KHz,4us��OFDM��Ԫʱ��
	--����:clkΪ������,ʹ��rst,clk����,sig_flagΪ1ʱ,����⵽��������,����LED,ͬ����ʼ��־syn_start_flag��1,��ʼ����4usͬ��ʱ��syn_clk_4us,
	--���ɵķ������Ǽ�����countnumber����100MHzʱ��,����200��һ��ת,ʱ�Ӿ���4us
	-------------------------------------------------------------------------------------------
	--ctrl��inv_ctrl����tag������״̬:���մ�������,����ź�
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
	
	--�ظ�����ģ��
	--����:��һ�δ������֮��,��ctl����1,�൱���Զ�rst
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
	------------shift_outputģ���dynamic_choose��ֵ�ÿ����޸�,ʹ�ñ�׼DPL�ȽϺ�--------------

	--��ģ�齫Ƶ��ʱ�ӷֳ�16����ͬ��λ������λ����
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

	--��λ����ģ��
	--����:��16����ͬ��λ��Ƶ��ʱ����ѡȡ��һ������Ԫʱ����Ϊͬ����һ��Ƶ��ʱ��,choose_result_of_16freq��¼�����
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
    ---------------------------------------���ģ����----------------------------------------
	--217�����ģ��
	--����:clkʹ��rom_output_clk_8us,�������245λbit,��������490λbit
	component con_217
	    port(
			clk     : in std_logic;
			rst     : in std_logic;
			ctl     : in std_logic;
			datain  : in std_logic_vector (0 downto 0);
			dataout : out std_logic_vector (1 downto 0)
	    	);
	end component;
	
	--����ά����������Ϊһά������
	component output
	    port(
			clk       : in std_logic;
			rst       : in std_logic;
			ctl       : in std_logic;
			dataout   : in std_logic_vector (1 downto 0);
			bitstream : out std_logic
        	);
	 end component;
	 
	--�������ģ��,��490λ֮ǰ����һЩbit��overhead,����ʵ�ָ��ֹ���
	--����:��һλ������֮ǰ����8λtag-to-receiver��ǰ�����������Խ��ջ��Ǳߵ�����ͼ��λ����
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
	--------------------------------�����������---------------------------------------------
	--����:����dynamic_chooseѡ�������,��ʮ����Ƶ��ʱ��ѡ��һ����Ȼ��д��temp_output_cos&sin�У�׼�����
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

	--����:BPSK����OOK���������������tagǰ�����һ�����Ӵ����
	with bitout select
	    Output_cos <= 
	    	temp_output_cos_0_degree    when '0',
		    temp_output_cos_180_invert  when others;
    with bitout select
	    Output_sin <= 
	    	temp_output_sin_0_degree    when '0',
		    temp_output_sin_180_invert  when others;

end Behavioral;

---------------------------�������룬��Ҫ����---------------------------------
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


----��ģ��û���õ�,���ÿ���

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
----��ģ��û���õ�,���ÿ���
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