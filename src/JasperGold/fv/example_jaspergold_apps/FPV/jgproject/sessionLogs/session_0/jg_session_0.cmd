#----------------------------------------
# JasperGold Version Info
# tool      : JasperGold 2019.03
# platform  : Linux 3.10.0-1062.el7.x86_64
# version   : 2019.03p002 64 bits
# build date: 2019.06.01 18:04:02 PDT
#----------------------------------------
# started Tue Dec 17 21:50:57 EST 2019
# hostname  : cadpc14
# pid       : 14159
# arguments : '-label' 'session_0' '-console' 'cadpc14:37237' '-style' 'windows' '-data' 'AQAAADx/////AAAAAAAAA3oBAAAAEABMAE0AUgBFAE0ATwBWAEU=' '-proj' '/homes/user/stud/fall19/hz2619/fv/example_jaspergold_apps/FPV/jgproject/sessionLogs/session_0' '-init' '-hidden' '/homes/user/stud/fall19/hz2619/fv/example_jaspergold_apps/FPV/jgproject/.tmp/.initCmds.tcl' 'FPV_verilog_hanoi.tcl'
# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

# Analyze design under verification files
set ROOT_PATH ../designs/reference_design/verilog_sva
set RTL_PATH ${ROOT_PATH}/source/design
set PROP_PATH ${ROOT_PATH}/source/properties

analyze -sv \
  ${RTL_PATH}/towersofhanoi54.sv \

# Elaborate design and properties
elaborate -top move_disk

# Set up Clocks and Resets
clock clk
reset rst

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

