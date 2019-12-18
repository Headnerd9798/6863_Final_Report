# -------------------------------------------------------
# Copyright (c) 2017 Cadence Design Systems, Inc.
#
# All rights reserved.
#
# Jasper Design Automation Proprietary and Confidential.
# -------------------------------------------------------

clear -all

check_xprop -init_control 1

# Analyze design under verification files
set RTL_PATH ../designs/reference_design/verilog_sva/source/design

analyze -verilog \
  ${RTL_PATH}/arbiter.v \
  ${RTL_PATH}/port_select.v \
  ${RTL_PATH}/bridge.v \
  ${RTL_PATH}/egress.v \
  ${RTL_PATH}/ingress.v \
  ${RTL_PATH}/top.v

# Elaborate design and properties
elaborate -top top

# Set up clocks and resets
clock clk
reset ~rstN

# Get design information to check general complexity
get_design_info

# Extract X-propagation properties from the design
check_xprop -create -outputs -no_bit_blast
check_xprop -create -control -no_bit_blast
check_xprop -create -clocks_and_resets -no_bit_blast

# Prove properties
set_max_trace_length 10 
check_xprop -prove -no_decompose -all

# Report proof results
report



