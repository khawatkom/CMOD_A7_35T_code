// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Tue Sep 25 14:31:56 2018
// Host        : DESKTOP-J9CTS4D running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/Vivado2017/VivadoProjects/CMOD_A7_SECOND_EDITION/CMOD_A7_SECOND_EDITION.runs/rom224_synth_1/rom224_stub.v
// Design      : rom224
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2017.4" *)
module rom224(a, spo)
/* synthesis syn_black_box black_box_pad_pin="a[10:0],spo[0:0]" */;
  input [10:0]a;
  output [0:0]spo;
endmodule
