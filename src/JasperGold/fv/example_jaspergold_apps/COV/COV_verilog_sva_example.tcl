# ----------------------------------------
#  Copyright (C) 2016 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

clear -all

# Analyze design under verification files
set ROOT_PATH ../designs/reference_design/verilog_sva
set RTL_PATH ${ROOT_PATH}/source/design
set PROP_PATH ${ROOT_PATH}/source/properties

########################################################
# Initialize the Coverage App before elaboration
########################################################
# -exclude_bind_hierarchies will prevent generating code coverage for testbench code
check_cov -init -model {branch statement expression toggle functional} -toggle_ports_only -exclude_bind_hierarchies

analyze -verilog \
  ${RTL_PATH}/arbiter.v \
  ${RTL_PATH}/port_select.v \
  ${RTL_PATH}/bridge.v \
  ${RTL_PATH}/egress.v \
  ${RTL_PATH}/ingress.v \
  ${RTL_PATH}/top.v

# Analyze property files
analyze -sva \
  ${PROP_PATH}/bindings.sva \
  ${PROP_PATH}/v_arbiter.sva \
  ${PROP_PATH}/v_bridge.sva \
  ${PROP_PATH}/v_ingress.sva \
  ${PROP_PATH}/v_egress.sva \
  ${PROP_PATH}/v_port_select.sva

# Elaborate design and properties, enabling covergroups
elaborate -top top

# Set up Clocks and Resets
clock clk
reset ~rstN

# Prove asserts and covers
set_max_trace_length 9
prove -all

########################################################
# Generate all coverage metrics
########################################################

#-no_auto disables auto-prove strategy for stimuli measure
#-max_jobs 0 allows all metric measure in parallel based on specified/default engines
check_cov -measure -no_auto

