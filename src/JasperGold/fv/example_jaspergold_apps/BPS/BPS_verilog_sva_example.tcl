# ----------------------------------------
# Copyright (c) 2017 Cadence Design Systems, Inc. All Rights Reserved.
# Unpublished -- rights reserved under the copyright laws of the United States.
# ----------------------------------------


set VCD_PATH ../designs/reference_design/verilog_sva
set RTL_PATH ../designs/reference_design/verilog_sva/source

# Read in HDL files
analyze -clear

analyze -verilog ${RTL_PATH}/design/arbiter.v
analyze -verilog ${RTL_PATH}/design/bridge.v
analyze -verilog ${RTL_PATH}/design/egress.v
analyze -verilog ${RTL_PATH}/design/ingress.v
analyze -verilog ${RTL_PATH}/design/port_select.v
analyze -verilog ${RTL_PATH}/design/top.v

analyze -sv ${RTL_PATH}/properties/bindings.sva
analyze -sv ${RTL_PATH}/properties/v_arbiter.sva
analyze -sv ${RTL_PATH}/properties/v_bridge.sva
analyze -sv ${RTL_PATH}/properties/v_egress.sva
analyze -sv ${RTL_PATH}/properties/v_ingress.sva
analyze -sv ${RTL_PATH}/properties/v_port_select.sva

elaborate -bbox_a 1024

clock clk
reset {rstN == 1'b0}
waveform -reset rstN==0

# Extract Points of Interest (POIs)
scope -extract all
scope -add ready0 ready1 ready2 ready3
scope -add eg.cur_state eg.read_write brdg.current_read_write

# Scan trace and synthesize property candidates
check_bps -scan -trace -vcd ${VCD_PATH}/vcd/e154.vcd

# Capture property baseline
database -set_baseline -bps

# Scan trace and synthesize more property candidates
check_bps -scan -trace -vcd ${VCD_PATH}/vcd/e155.vcd
check_bps -scan -trace -vcd ${VCD_PATH}/vcd/e156.vcd

# export and prove in FPV app
check_bps -export -class unclassified -type cover
set_current_gui fpv
prove -task <synthesized> -time_limit 30s
set_current_gui bps

# Export Property Candidates
export -bps -to_sva [get_proj_dir]/example.sva \
    -to_tcl [get_proj_dir]/connect_sva.tcl \
    -type coverage_hole -type exercised_cover \
    -class certified -class unclassified 
export -bps -to_html [get_proj_dir]/example.htm \
    -type coverage_hole -type exercised_cover \
    -class certified -class unclassified 
