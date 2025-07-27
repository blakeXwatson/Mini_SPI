##Clock
#IO_L13P_T2_MRCC_35 Schematic name=SYSCLK
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports clk]


# C3
set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports cs]

# C42
#create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports sclk]
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports sclk]
#set_property CLOCK_DEDICATED_ROUTE [get_ports sclk]

# C2
set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS33} [get_ports miso]
set_property DRIVE 4 [get_ports miso]

# C6
set_property -dict {PACKAGE_PIN R12 IOSTANDARD LVCMOS33} [get_ports mosi]


# LEDs
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN M12 IOSTANDARD LVCMOS33} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {led[7]}]


#set_property SLEW SLOW [get_ports cs]


