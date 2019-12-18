# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

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

# Set up proof environment
clock clk
reset ~rstN

# Load connectivity table 
check_conn -load conn.csv

# Prove connectivity properties
check_conn -prove 

# Report results
report
