# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

# Analyze design under verification files
set ROOT_PATH ../designs/reference_design/vhdl_sva
set RTL_PATH ${ROOT_PATH}/source/design
set TOP_PATH ../designs/reference_design/verilog_sva/source/design
set PROP_PATH ${ROOT_PATH}/source/properties

analyze -vhdl -lib MY_LIB \
  ${RTL_PATH}/arbiter.vhd \
  ${RTL_PATH}/port_select.vhd \
  ${RTL_PATH}/bridge.vhd \
  ${RTL_PATH}/egress.vhd \
  ${RTL_PATH}/ingress.vhd 

analyze -verilog -lib MY_LIB ${TOP_PATH}/top.v

# Analyze property files
analyze -sva -lib MY_LIB\
  ${PROP_PATH}/bindings.sva \
  ${PROP_PATH}/v_arbiter.sva \
  ${PROP_PATH}/v_bridge.sva \
  ${PROP_PATH}/v_ingress.sva \
  ${PROP_PATH}/v_egress.sva \
  ${PROP_PATH}/v_port_select.sva


# Elaborate design and properties
elaborate -top MY_LIB.top

# Set up Clocks and Resets
clock clk
reset ~rstN

# Get design information to check general complexity
get_design_info

# Prove properties
# 1st pass: Quick validation of properties with default engines
set_max_trace_length 10
prove -all
#
# 2nd pass: Validation of remaining properties with different engines
set_max_trace_length 50
set_prove_per_property_time_limit 30s
set_engine_mode {K I N} 
prove -all

# Report proof results
report

