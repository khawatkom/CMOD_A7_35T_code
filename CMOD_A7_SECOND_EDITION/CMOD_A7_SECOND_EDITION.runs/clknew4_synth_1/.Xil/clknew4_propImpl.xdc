set_property SRC_FILE_INFO {cfile:e:/Vivado2017/VivadoProjects/CMOD_A7_SECOND_EDITION/CMOD_A7_SECOND_EDITION.srcs/sources_1/ip/clknew4/clknew4.xdc rfile:../../../CMOD_A7_SECOND_EDITION.srcs/sources_1/ip/clknew4/clknew4.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
