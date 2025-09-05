# Digital Clock with Alarm - Basys 3 FPGA Constraints
# Project: Digital Design Project 2
# Authors: Adham Ali, Omar Saqr, Ebram Thabet
# Target Device: Basys 3 FPGA Board (XC7A35T-1CPG236C)

# System Clock (100 MHz)
set_property PACKAGE_PIN W5 [get_ports {clk}]					
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]	

# Reset Button (SW0)
set_property PACKAGE_PIN V17 [get_ports {reset}]					
set_property IOSTANDARD LVCMOS33 [get_ports {reset}]

# Enable Switch (SW1)
set_property PACKAGE_PIN R2 [get_ports {enable}]					
set_property IOSTANDARD LVCMOS33 [get_ports {enable}]

# Seven Segment Display Segments
set_property PACKAGE_PIN U7 [get_ports {segments[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[0]}]

set_property PACKAGE_PIN V5 [get_ports {segments[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[1]}]

set_property PACKAGE_PIN U5 [get_ports {segments[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[2]}]

set_property PACKAGE_PIN V8 [get_ports {segments[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[3]}]

set_property PACKAGE_PIN U8 [get_ports {segments[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[4]}]

set_property PACKAGE_PIN W6 [get_ports {segments[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[5]}]

set_property PACKAGE_PIN W7 [get_ports {segments[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[6]}]

# Seven Segment Display Decimal Point
set_property PACKAGE_PIN V7 [get_ports decimal]
set_property IOSTANDARD LVCMOS33 [get_ports decimal]

# Seven Segment Display Anodes
set_property PACKAGE_PIN W4 [get_ports {anode_active[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_active[0]}]

set_property PACKAGE_PIN V4 [get_ports {anode_active[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_active[1]}]

set_property PACKAGE_PIN U4 [get_ports {anode_active[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_active[2]}]

set_property PACKAGE_PIN U2 [get_ports {anode_active[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode_active[3]}]

# Push Buttons
set_property PACKAGE_PIN U18 [get_ports C]    # BTNC - Center button
set_property IOSTANDARD LVCMOS33 [get_ports C]

set_property PACKAGE_PIN W19 [get_ports L]    # BTNL - Left button  
set_property IOSTANDARD LVCMOS33 [get_ports L]

set_property PACKAGE_PIN T17 [get_ports R]    # BTNR - Right button
set_property IOSTANDARD LVCMOS33 [get_ports R]

set_property PACKAGE_PIN T18 [get_ports U]    # BTNU - Up button
set_property IOSTANDARD LVCMOS33 [get_ports U]

set_property PACKAGE_PIN U17 [get_ports D]    # BTND - Down button
set_property IOSTANDARD LVCMOS33 [get_ports D]

# LEDs for Status Indication
set_property PACKAGE_PIN U16 [get_ports {LD[0]}]   # LD0 - Alarm indicator
set_property IOSTANDARD LVCMOS33 [get_ports {LD[0]}]

set_property PACKAGE_PIN P3 [get_ports {LD[1]}]    # LD1 - Mode indicator
set_property IOSTANDARD LVCMOS33 [get_ports {LD[1]}]

set_property PACKAGE_PIN N3 [get_ports {LD[2]}]    # LD2 - Mode indicator
set_property IOSTANDARD LVCMOS33 [get_ports {LD[2]}]

set_property PACKAGE_PIN P1 [get_ports {LD[3]}]    # LD3 - Mode indicator
set_property IOSTANDARD LVCMOS33 [get_ports {LD[3]}]

set_property PACKAGE_PIN L1 [get_ports {LD[4]}]    # LD4 - Mode indicator
set_property IOSTANDARD LVCMOS33 [get_ports {LD[4]}]

# Buzzer Output (JA1)
set_property PACKAGE_PIN M18 [get_ports {buzz_en}]
set_property IOSTANDARD LVCMOS33 [get_ports {buzz_en}]
