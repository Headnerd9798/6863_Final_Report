# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

proc setup {} {
  # Specify clock, reset and any other setup, if any,  after design is elaborated.
    clock clk
    reset reset

    assert -disable *::*
    cover -disable *::*
    assert -enable "<embedded>::top.efficiency"
    #power port vdd is always on
    assume -env { vdd_net } -name vdd_net_always_on -replace_if

}

clear -all
set PATH "../designs/lpv_design"
set_engine_mode {Ht Hp B N}
set_prove_time_limit 100s

#Analyze and elaborate
analyze -sv {*}[glob $PATH/*.v]

elaborate -clear
elaborate -top top

#Load in power specification files.  LPV App detects potential issues and return warnings/errors.
check_lpv -load_upf top.upf;

#Automatically creates power aware RTL
check_lpv -generate_power_design

#Reload setup
setup

#Examples of some automatic structural checks.
check_lpv -verify check_iso_clk_all
check_lpv -verify check_iso_inputs
check_lpv -verify check_iso_outputs
check_lpv -verify check_iso_ctrl_rst
check_lpv -verify check_iso_connections
check_lpv -verify check_ret_connections
check_lpv -verify check_iso_default_value
check_lpv -verify check_ret_ctrl_rst
check_lpv -verify check_power_switch_connections
check_lpv -verify check_power_switch_ctrl_rst

#Examples of some automatic funcational  checks
check_lpv -create assert_iso_up_before
check_lpv -create assert_iso_supply
check_lpv -create assert_iso_up_after
check_lpv -create assert_iso_up_clk_stable
check_lpv -create assert_iso_change_signal_stable
check_lpv -create assert_clock_stable_after_restore
check_lpv -create assert_ret_supply_on_save
check_lpv -create assert_ret_supply_on_restore
check_lpv -create assert_ret_supply_on_from_save_to_restore
check_lpv -create cover_power_switch_ctrl
check_lpv -create cover_iso_ctrl
check_lpv -create cover_ret_save_ctrl

#Run LPV proof
prove -property <LowPower>::lpv::*

#Visualize CEX
visualize -violation -property <LowPower>::lpv::iso_up_after_iso_output__PD_MEM -new_window
