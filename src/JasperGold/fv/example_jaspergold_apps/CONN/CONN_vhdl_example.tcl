# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

# Analyze design under verification files
set RTL_PATH ../designs/reference_design/vhdl_psl/source/design

analyze -vhdl \
  ${RTL_PATH}/arbiter.vhd \
  ${RTL_PATH}/port_select.vhd \
  ${RTL_PATH}/bridge.vhd \
  ${RTL_PATH}/egress.vhd \
  ${RTL_PATH}/ingress.vhd \
  ${RTL_PATH}/top.vhd
# Elaborate design and properties
elaborate -vhdl -top top(rtl) -mode verilog

# Set up proof environment
clock clk
reset {~rstN}

# Load connectivity table 
check_conn -load conn.csv

# Prove connectivity properties
check_conn -prove 

# Report results
report
