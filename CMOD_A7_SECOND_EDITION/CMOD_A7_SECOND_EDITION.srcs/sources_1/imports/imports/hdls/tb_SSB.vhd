
--此部分为testbench
--套路还是比较明显的，可以看着按需求改改

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_SSB IS
END tb_SSB;

ARCHITECTURE behavior OF tb_SSB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
  
    COMPONENT SSB
    PORT(
         primary_clk                : in  std_logic;               --主晶振12MHz
         btn_enable_tag_Rx          : in   STD_LOGIC;              --使能tag的接收模块
         rst                        : in   STD_LOGIC;              --重启tag
         Input_from_Tag             : in   std_logic;              --比较器输出信号即前导序列
         Enable_to_Tag              : out  std_logic;              --使能tag的接收模块        
         LED_flag_of_FPGA_start     : out  STD_LOGIC;              --标识FPGA是否使能
         LED_flag_of_TiggerSequence : out  std_logic;              --标识tag#4是否接收到前导序列
         Output_cos                 : out  std_logic;              --频移量cos输出
         Output_sin                 : out  std_logic;              --频移量sin输出
         ctrl                       : inout  std_logic;            --控制Tag的紧接天线输入后的二选一开关,选择是走哪一条路
         inv_ctrl                   : inout  std_logic             --与ctrl相反,两者结合使用,同一功能
        );
    END COMPONENT;
    
    signal barker        : std_logic_vector(0 to 43):= "11010010110111010010110111011101001000100010";

    --Inputs
    signal clk           : std_logic := '0';
    signal btnC          : std_logic := '0';
    signal rst           : std_logic := '0';
    signal jb4           : std_logic := '0';
    --Outputs
    signal jc4           : std_logic;
    signal ld0           : std_logic;
    signal ld4           : std_logic;
    signal output4_1     : std_logic;
    signal output4_2     : std_logic;
    signal ctrl          : std_logic;
    signal inv_ctrl      : std_logic;
    -- Clock period definitions
    constant clk_period  : time := 10 ns;
    constant clk_primary : time := 83.3333 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
    uut:SSB PORT MAP (
        primary_clk                => clk,
        btn_enable_tag_Rx          => btnC,
        rst                        => rst,
        Input_from_Tag             => jb4,
        Enable_to_Tag              => jc4,
        LED_flag_of_FPGA_start     => ld0,
        LED_flag_of_TiggerSequence => ld4,
        Output_cos                 => output4_1,
        Output_sin                 => output4_2,
        ctrl                       => ctrl,
        inv_ctrl => inv_ctrl
        );

   --Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_primary/2;
        clk <= '1';
        wait for clk_primary/2;
    end process;

    jb4_process :process
    begin
    jb4 <= '0';
        wait for 5000*clk_period;
    for i in 0 to barker'HIGH loop
        jb4 <= barker(i);
        wait for 100*clk_period;
    end loop;

    wait for 40000*clk_period;

  end process;

    stim_proc: process
    begin    
        -- hold reset state.
        wait for 100 ns;  

        wait for clk_period*100;

        -- insert stimulus here 
    rst <= '1',
        '0' after clk_period*2000;
       
    btnC <= '0',
        '1' after clk_period*2500,
        '0' after clk_period*5000;
        wait;
   end process;

END;