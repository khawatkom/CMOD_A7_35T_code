
set_property PACKAGE_PIN C16 [get_ports ld4]
set_property IOSTANDARD LVCMOS33 [get_ports ld4]

set_property PACKAGE_PIN A18 [get_ports btnC]
set_property PACKAGE_PIN B18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports btnC]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property PACKAGE_PIN J19 [get_ports jb4]
set_property PACKAGE_PIN N18 [get_ports jc4]
set_property PACKAGE_PIN A17 [get_ports ld0]
set_property PACKAGE_PIN G17 [get_ports output4_1]
set_property PACKAGE_PIN H17 [get_ports output4_2]
set_property IOSTANDARD LVCMOS33 [get_ports jb4]
set_property IOSTANDARD LVCMOS33 [get_ports jc4]
set_property IOSTANDARD LVCMOS33 [get_ports ld0]
set_property IOSTANDARD LVCMOS33 [get_ports output4_1]
set_property IOSTANDARD LVCMOS33 [get_ports output4_2]


set_switching_activity -toggle_rate 0.000 -static_probability 0.000 [get_nets rst_IBUF]
