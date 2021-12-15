# VGA related
set_property IOSTANDARD LVCMOS33 [get_ports {O_blue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_blue[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_blue[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_blue[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_green[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_green[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_green[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_green[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_red[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_red[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_red[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {O_red[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports O_hs]
set_property IOSTANDARD LVCMOS33 [get_ports O_vs]
set_property PACKAGE_PIN H20 [get_ports {O_blue[0]}]
set_property PACKAGE_PIN G20 [get_ports {O_blue[1]}]
set_property PACKAGE_PIN K21 [get_ports {O_blue[2]}]
set_property PACKAGE_PIN K22 [get_ports {O_blue[3]}]
set_property PACKAGE_PIN H17 [get_ports {O_green[0]}]
set_property PACKAGE_PIN H18 [get_ports {O_green[1]}]
set_property PACKAGE_PIN J22 [get_ports {O_green[2]}]
set_property PACKAGE_PIN H22 [get_ports {O_green[3]}]
set_property PACKAGE_PIN G17 [get_ports {O_red[0]}]
set_property PACKAGE_PIN G18 [get_ports {O_red[1]}]
set_property PACKAGE_PIN J15 [get_ports {O_red[2]}]
set_property PACKAGE_PIN H15 [get_ports {O_red[3]}]
set_property PACKAGE_PIN M21 [get_ports O_hs]
set_property PACKAGE_PIN L21 [get_ports O_vs]

# clock and reset
set_property IOSTANDARD LVCMOS33 [get_ports I_clk_100M]
set_property IOSTANDARD LVCMOS33 [get_ports I_rst_n]
set_property PACKAGE_PIN Y18 [get_ports I_clk_100M]
set_property PACKAGE_PIN Y9 [get_ports I_rst_n]

# series port
set_property IOSTANDARD LVCMOS33 [get_ports I_uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports O_uart_tx]
set_property PACKAGE_PIN Y19 [get_ports I_uart_rx]
set_property PACKAGE_PIN V18 [get_ports O_uart_tx]

# LED of status "transimitting"
set_property IOSTANDARD LVCMOS33 [get_ports O_transmitting]
set_property PACKAGE_PIN A21 [get_ports O_transmitting]

# Switches controlling the permutation of puzzle
set_property IOSTANDARD LVCMOS33 [get_ports {I_num[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {I_num[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {I_num[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {I_num[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {I_num[4]}]
set_property PACKAGE_PIN W9 [get_ports {I_num[0]}]
set_property PACKAGE_PIN Y7 [get_ports {I_num[1]}]
set_property PACKAGE_PIN Y8 [get_ports {I_num[2]}]
set_property PACKAGE_PIN AB8 [get_ports {I_num[3]}]
set_property PACKAGE_PIN AA8 [get_ports {I_num[4]}]

# Switch controlling the display of blackhole
set_property IOSTANDARD LVCMOS33 [get_ports I_black_EN]
set_property PACKAGE_PIN V8 [get_ports I_black_EN]

# Up, down, left and right button and set button
set_property IOSTANDARD LVCMOS33 [get_ports I_btn_set]
set_property IOSTANDARD LVCMOS33 [get_ports I_btn_up]
set_property IOSTANDARD LVCMOS33 [get_ports I_btn_down]
set_property IOSTANDARD LVCMOS33 [get_ports I_btn_left]
set_property IOSTANDARD LVCMOS33 [get_ports I_btn_right]
set_property PACKAGE_PIN P4 [get_ports I_btn_set]
set_property PACKAGE_PIN P5 [get_ports I_btn_up]
set_property PACKAGE_PIN P2 [get_ports I_btn_down]
set_property PACKAGE_PIN R1 [get_ports I_btn_right]
set_property PACKAGE_PIN P1 [get_ports I_btn_left]

# Button of random function
set_property IOSTANDARD LVCMOS33 [get_ports I_btn_rand]
set_property PACKAGE_PIN S6 [get_ports I_btn_rand]

# LED of status "completed"
set_property IOSTANDARD LVCMOS33 [get_ports O_completed]
set_property PACKAGE_PIN E22 [get_ports O_completed]