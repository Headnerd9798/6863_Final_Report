# ----------------------------------------
# Copyright (C) 2017 Cadence Design Systems, Inc. All Rights Reserved.
# Unpublished -- rights reserved under the copyright laws of the United States.
# ----------------------------------------

# Initialize Superlint App
check_superlint  -init

# Read in HDL files
set RTL_PATH ../designs/reference_design/vhdl_sva/source/design

analyze -clear
analyze -vhdl \
  ${RTL_PATH}/arbiter.vhd \
  ${RTL_PATH}/port_select.vhd \
  ${RTL_PATH}/bridge.vhd \
  ${RTL_PATH}/egress.vhd \
  ${RTL_PATH}/ingress.vhd \
  ${RTL_PATH}/top.vhd

# Elaborate design 
elaborate -bbox_a 1024

# Setup clocks and reset
clock clk
reset {rstN == 1'b0}

# Extract the checks 
check_superlint -extract

# Add assumptions for Arithmetic overflow checks
assume {brdg.wr_ptr < 4'b1111} 
assume {brdg.rd_ptr < 4'b1111}

# Create task for assumptions and copy the assumptions from embedded task
task -create design_assumptions -copy_assumes -copy_related_covers -source_task <embedded>

#Link the design assumptions task to Superlint task
task -link design_assumptions -to <SL_AUTO_FORMAL_ARITHMETIC_OVERFLOW>

# prove extracted properties
set_max_trace_length 50
check_superlint -prove -task {<SL_*}
