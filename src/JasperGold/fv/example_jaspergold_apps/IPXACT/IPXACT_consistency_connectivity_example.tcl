set env(DESIGN_PATH) [get_install_dir]/doc/example_jaspergold_apps/designs/ipxact_design
set env(DEMO_PATH) [pwd]

# This command loads the IPXACT and sets up the design
ipxact -load ipxact/top.xml -lib ipxact -setup design

# Checks consistency of design declaration in IP-XACT and RTL in terms of ports, parameters, instances
ipxact -check_rtl_consistency

# The IP-XACT Definition can also be used to setup the Jaspergold Connectivity App
ipxact -generate_connectivity_map [get_proj_dir]/conn.csv orpsoc_top
check_conn -load [get_proj_dir]/conn.csv

# Auto-detection of clocks and resets
clock -analyze
reset -analyze

# Set up clock and reset
clock clk_pad_i
reset ~rst_n_pad_i

# Prove connectivity properties
check_conn -prove
