-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Tue Sep 25 14:31:56 2018
-- Host        : DESKTOP-J9CTS4D running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               E:/Vivado2017/VivadoProjects/CMOD_A7_SECOND_EDITION/CMOD_A7_SECOND_EDITION.runs/rom224_synth_1/rom224_stub.vhdl
-- Design      : rom224
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom224 is
  Port ( 
    a : in STD_LOGIC_VECTOR ( 10 downto 0 );
    spo : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end rom224;

architecture stub of rom224 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a[10:0],spo[0:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dist_mem_gen_v8_0_12,Vivado 2017.4";
begin
end;
