# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

# Analyze design under verification files
set ROOT_PATH ../designs/reference_design/vhdl_psl
set RTL_PATH ${ROOT_PATH}/source/design
set PROP_PATH ${ROOT_PATH}/source/properties

analyze -vhdl \
  ${RTL_PATH}/arbiter.vhd \
  ${RTL_PATH}/port_select.vhd \
  ${RTL_PATH}/bridge.vhd \
  ${RTL_PATH}/egress.vhd \
  ${RTL_PATH}/ingress.vhd \
  ${RTL_PATH}/top.vhd

# Analyze property files
analyze -vhdl -psl \
  ${PROP_PATH}/v_arbiter.vhd.psl \
  ${PROP_PATH}/v_bridge.vhd.psl \
  ${PROP_PATH}/v_ingress.vhd.psl \
  ${PROP_PATH}/v_egress.vhd.psl \
  ${PROP_PATH}/v_port_select.vhd.psl
  
# Elaborate design and properties
elaborate -vhdl -top top(rtl)

# Set up Clocks and Resets
clock clk
reset {rstN = "0"}

# Get design information to check general complexity
get_design_info

# Prove properties
# 1st pass: Quick validation of properties with default engines
set_max_trace_length 10
prove -all
#
# 2nd pass: Validation of remaining properties with different engine
set_max_trace_length 50
set_prove_per_property_time_limit 30s
set_engine_mode {K I N} 
prove -all

# Report proof results
report

