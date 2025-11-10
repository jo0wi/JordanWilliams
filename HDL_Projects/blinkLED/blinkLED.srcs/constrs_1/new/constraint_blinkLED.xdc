set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {LED}];
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {clk}];
create_clock -name sysclk -period 10 [get_ports {clk}]; 