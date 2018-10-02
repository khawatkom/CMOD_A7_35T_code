-makelib ies_lib/xil_defaultlib -sv \
  "E:/Vivado2017/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "E:/Vivado2017/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../ip/clknew4/clknew4_clk_wiz.v" \
  "../../../ip/clknew4/clknew4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

