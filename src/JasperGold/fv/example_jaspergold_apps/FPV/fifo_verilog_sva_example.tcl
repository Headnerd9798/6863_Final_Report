# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

# Analyze design under verification files
set ROOT_PATH /user/stud/fall19/hz2619/fv/example_jaspergold_apps/designs/reference_design/verilog_sva
set RTL_PATH ${ROOT_PATH}/source/design
set PROP_PATH ${ROOT_PATH}/source/properties


analyze -sv \
  ${RTL_PATH}/fifo.sv 


# Analyze property files

  
# Elaborate design and properties
elaborate -top fifo

# Set up Clocks and Resets
clock clk
reset rst

# Get design information to check general complexity
get_design_info

# Prove properties

# 1st pass: Quick validation of properties with default engines
set_max_trace_length 10
prove -all


# 2nd pass: Validation of remaining properties with different engine
set_max_trace_length 50
set_prove_per_property_time_limit 30s
set_engine_mode {K I N} 
prove -all

# Report proof results
report

