set env(DESIGN_PATH) [get_install_dir]/doc/example_jaspergold_apps/designs/ipxact_design
set env(DEMO_PATH) [pwd]

# The bind file is not needed in case of designs with AMBA ABVIP compatible interfaces (apb3/4, axi3/4, ahb_lite)
analyze -sv jasper_bind_csr.sv

# This command loads the IPXACT and sets up the design
ipxact -load ipxact/or1k.xml -lib ipxact -setup design

# Enable CSR
check_csr -load_ipxact -instance jasper_csr_checker0

# Set up clock and reset
clock clk_i
reset rst_i

# Prove CSR properties
check_csr -prove
