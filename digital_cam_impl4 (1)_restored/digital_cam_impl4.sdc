#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************

create_clock -period 20.000ns [get_ports clk_50]

create_clock -period 33.333ns  -name ov7670_pclk[get_ports ov7670_pclk]
create_clock -period "100 MHz" -name clk_dram [get_ports DRAM_CLK]
# AUDIO : 48kHz 384fs 32-bit data
create_clock -period "18.432 MHz" -name clk_audxck [get_ports AUD_XCK]
create_clock -period "1.536 MH" -name clk_audbck [get_ports AUD_BCLK]
# VGA : 640x480@60Hz
#create_clock -period "25.18 MHz" -name clk_vga [get_ports vga_CLK]
# VGA : 800x600@60Hz
#create_clock -period "40.0 MHz" -name clk_vga [get_ports VGA_CLK]
# VGA : 1024x768@60Hz
#create_clock -period "65.0 MHz" -name clk_vga [get_ports VGA_CLK]
# VGA : 1280x1024@60Hz
create_clock -period "108.0 MHz" -name clk_vga [get_ports vga_CLK]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
# Board Delay (Data) + Propagation Delay - Board Delay (Clock)





#**************************************************************
# Set Output Delay
#**************************************************************
# max : Board Delay (Data) - Board Delay (Clock) + tsu (External Device)
# min : Board Delay (Data) - Board Delay (Clock) - th (External Device)
set_output_delay -max -clock clk_vga 0.220 [get_ports vga_r*]
set_output_delay -min -clock clk_vga -1.506 [get_ports vga_r*]
set_output_delay -max -clock clk_vga 0.212 [get_ports vga_g*]
set_output_delay -min -clock clk_vga -1.519 [get_ports vga_g*]
set_output_delay -max -clock clk_vga 0.264 [get_ports vga_b*]
set_output_delay -min -clock clk_vga -1.519 [get_ports vga_b*]
set_output_delay -max -clock clk_vga 0.215 [get_ports vga_blank_n]
set_output_delay -min -clock clk_vga -1.485 [get_ports vga_blank_n]




#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



