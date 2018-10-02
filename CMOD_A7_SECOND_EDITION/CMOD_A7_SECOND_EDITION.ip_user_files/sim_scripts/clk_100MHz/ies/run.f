-makelib ies_lib/xil_defaultlib -sv \
  "E:/Vivado2017/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "E:/Vivado2017/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../ip/clk_100MHz/clk_100MHz_clk_wiz.v" \
  "../../../ip/clk_100MHz/clk_100MHz.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

