
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
         primary_clk : IN  std_logic;
         btnC : IN  std_logic;
         rst : IN  std_logic;
         --jb1 : IN  std_logic;
         --jb2:  in std_logic;
         --jb3:  in std_logic;
         jb4:  in std_logic;
         --jc1 : OUT  std_logic;
         --jc2: out std_logic;
         --jc3: out std_logic;
         jc4: out std_logic;
         ld0 : OUT  std_logic;
         --ld1: out std_logic;
         --ld2 : OUT  std_logic;
         --ld3: out std_logic;
         ld4: out std_logic;
         --output1_1:out std_logic;
         --output1_2:out std_logic;
         --output2_1: out std_logic;
         --output2_2: out std_logic;
         --output3_1: out std_logic;
         --output3_2: out std_logic;
         output4_1: out std_logic;
         output4_2: out std_logic
        --ctrl: inout std_logic;
        --inv_ctrl: inout std_logic;
        --ctrl2: inout std_logic;
        --inv_ctrl2: inout std_logic;
        --ctrl3: inout std_logic;
        --inv_ctrl3: inout std_logic;
        --ctrl4: inout std_logic;
        --inv_ctrl4: inout std_logic      
        );
    END COMPONENT;
    
   signal barker : std_logic_vector(0 to 43):= "11010010110111010010110111011101001000100010";

   --Inputs
   signal clk : std_logic := '0';
   signal btnC : std_logic := '0';
   signal rst : std_logic := '0';
   signal jb1 : std_logic := '0';
   signal jb2: std_logic := '0';
   signal jb3: std_logic := '0';
   signal jb4: std_logic := '0';
  --Outputs
   signal jc1 : std_logic;
   signal jc2: std_logic;
   signal jc3: std_logic;
   signal jc4: std_logic;
   signal ld0 : std_logic;
   signal ld1: std_logic;
   signal ld2 : std_logic;
   signal ld3 : std_logic;
   signal ld4 : std_logic;
  signal output1_1: std_logic;
  signal output1_2: std_logic;
  signal output2_1: std_logic;
    signal output2_2: std_logic;
  signal output3_1: std_logic;
    signal output3_2: std_logic;
  signal output4_1: std_logic;
    signal output4_2: std_logic;
  signal ctrl: std_logic;
  signal inv_ctrl: std_logic;
  signal ctrl2: std_logic;
    signal inv_ctrl2: std_logic;
  signal ctrl3: std_logic;
    signal inv_ctrl3: std_logic;
  signal ctrl4: std_logic;
    signal inv_ctrl4: std_logic;
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant clk_primary : time := 83.3333 ns;
   --signal clk : std_logic:='0';
 
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
   uut: SSB PORT MAP (
        primary_clk => clk,
        btnC => btnC,
        rst => rst,
          --jb1 => jb1,
          --jb2 => jb2,
          --jb3 => jb3,
          jb4 => jb4,
          --jc1 => jc1,
          --jc2 => jc2,
          --jc3 => jc3,
          jc4 => jc4,
          ld0 => ld0,
          --ld1 => ld1,
          --ld2 => ld2,
          --ld3 => ld3,
          ld4 => ld4,
        --output1_1 => output1_1,
        --output1_2 => output1_2,
        --output2_1 => output2_1,
      --  output2_2 => output2_2,
        --output3_1 => output3_1,
      --  output3_2 => output3_2,
        output4_1 => output4_1,
        output4_2 => output4_2
       --ctrl => ctrl,
       --inv_ctrl => inv_ctrl,
       --ctrl2 => ctrl2,
       --inv_ctrl2 => inv_ctrl2,
       --ctrl3 => ctrl3,
       --inv_ctrl3 => inv_ctrl3,
       --ctrl4 => ctrl4,
       --inv_ctrl4 => inv_ctrl4
        );

   --Clock process definitions
   clk_process :process
   begin
    clk <= '0';
    wait for clk_primary/2;
    clk <= '1';
    wait for clk_primary/2;
   end process;
 

--    jb1_process :process
--   begin
--     jb1 <= '0';
--    wait for 400*clk_period;
--    jb1 <= '1';
--    wait for 400*clk_period;
--    jb1 <= '0';
--    wait for 400*clk_period;
--    jb1 <= '1';
--    wait for 800*clk_period;
--    jb1 <= '0';
--    wait for 400*clk_period;
--    jb1 <= '1';
--    wait for 1200*clk_period;
--    jb1 <= '0';
--    wait for 1200*clk_period; 
--    jb1 <= '1';
--    wait for 40000*clk_period;
--   end process;
   
--    jb2_process :process
--  begin
--      jb2<= '0';
--       wait for 400*clk_period;
--       jb2 <= '1';
--       wait for 400*clk_period;
--       jb2 <= '0';
--       wait for 400*clk_period;
--       jb2 <= '1';
--       wait for 800*clk_period;
--       jb2 <= '0';
--       wait for 400*clk_period;
--       jb2 <= '1';
--       wait for 1200*clk_period;
--       jb2 <= '0';
--       wait for 1200*clk_period;    
--       jb2 <= '1';
--       wait for 40000*clk_period;
--  end process;

--    jb3_process :process
--   begin
--     jb3<= '0';
--    wait for 400*clk_period;
--    jb3 <= '1';
--    wait for 400*clk_period;
--    jb3 <= '0';
--    wait for 400*clk_period;
--    jb3 <= '1';
--    wait for 800*clk_period;
--    jb3 <= '0';
--    wait for 400*clk_period;
--    jb3 <= '1';
--    wait for 1200*clk_period;
--    jb3 <= '0';
--    wait for 1200*clk_period; 
--    jb3 <= '1';
--    wait for 40000*clk_period;
--   end process;

     jb4_process :process
  begin
      --jb4<= '0';
      --wait for 400*clk_period;
      --jb4 <= '1';
      --wait for 400*clk_period;
      --jb4 <= '0';
      --wait for 400*clk_period;
      --jb4 <= '1';
      --wait for 800*clk_period;
      --jb4 <= '0';
      --wait for 400*clk_period;
      --jb4 <= '1';
      --wait for 1200*clk_period;
      --jb4 <= '0';
      --wait for 1200*clk_period; 
      --jb4 <= '1';
      --wait for 40000*clk_period;

      ----1111100110101
      --jb4 <= '0';
      -- wait for 400*clk_period;
      -- jb4 <= '1';           
      -- wait for 2000*clk_period;
      -- jb4 <= '0';
      -- wait for 800*clk_period;
      -- jb4 <= '1';
      -- wait for 800*clk_period;
      -- jb4 <= '0';
      -- wait for 400*clk_period;
      -- jb4 <= '1';
      -- wait for 400*clk_period;
      -- jb4 <= '0';
      -- wait for 400*clk_period;    
      -- jb4 <= '1';
      -- wait for 40000*clk_period;
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
      -- hold reset state for 100 ns.
      wait for 100 ns;  

      wait for clk_period*100;

      -- insert stimulus here 
    rst <= '1',
       '0' after clk_period*2000;
       
    btnC <= '0',
        '1' after clk_period*2500,
        '0' after clk_period *5000;
      wait;
   end process;

END;