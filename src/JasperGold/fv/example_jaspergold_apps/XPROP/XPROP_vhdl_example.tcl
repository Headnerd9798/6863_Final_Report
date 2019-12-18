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
set RTL_PATH ../designs/reference_design/vhdl_sva/source/design

analyze -vhdl \
  ${RTL_PATH}/arbiter.vhd \
  ${RTL_PATH}/port_select.vhd \
  ${RTL_PATH}/bridge.vhd \
  ${RTL_PATH}/egress.vhd \
  ${RTL_PATH}/ingress.vhd \
  ${RTL_PATH}/top.vhd

# Elaborate design and properties
elaborate -vhdl -top top(rtl)

# Set up clocks and resets
clock clk
reset {rstN = "0"}

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



