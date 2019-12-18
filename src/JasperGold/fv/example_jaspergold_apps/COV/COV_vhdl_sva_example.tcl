# ----------------------------------------
#  Copyright (C) 2016 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

clear -all

# Analyze design under verification files
set ROOT_PATH ../designs/reference_design/vhdl_sva
set RTL_PATH ${ROOT_PATH}/source/design
set PROP_PATH ${ROOT_PATH}/source/properties

########################################################
# Initialize the Coverage App before elaboration
########################################################
# -type all option will collect all 4 coverage types, equivalent to -type {stimuli coi proof bound}
# Coverage model selection is statement and branch by default, equivalent to -model {statement branch}
# -exclude_bind_hierarchies will prevent generating code coverage for testbench code
check_cov -init -model {statement branch expression toggle functional} -toggle_ports_only -exclude_bind_hierarchies

analyze -vhdl \
  ${RTL_PATH}/arbiter.vhd \
  ${RTL_PATH}/port_select.vhd \
  ${RTL_PATH}/bridge.vhd \
  ${RTL_PATH}/egress.vhd \
  ${RTL_PATH}/ingress.vhd \
  ${RTL_PATH}/top.vhd

# Analyze property files
analyze -sva \
  ${PROP_PATH}/bindings.sva \
  ${PROP_PATH}/v_arbiter.sva \
  ${PROP_PATH}/v_bridge.sva \
  ${PROP_PATH}/v_ingress.sva \
  ${PROP_PATH}/v_egress.sva \
  ${PROP_PATH}/v_port_select.sva

# Elaborate design and properties
elaborate -vhdl -top top(rtl) -extract_covergroups

# Set up Clocks and Resets
clock clk
reset {rstN = "0"}

# Prove asserts and covers
set_max_trace_length 9
prove -all

########################################################
# Generate all coverage metrics
########################################################

#-no_auto disables auto-prove strategy for stimuli measure
#-max_jobs 0 allows all metric measure in parallel based on specified/default engines
check_cov -measure -no_auto

