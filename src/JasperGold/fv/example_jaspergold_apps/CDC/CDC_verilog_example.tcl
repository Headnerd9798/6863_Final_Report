# -------------------------------------------------------
# Copyright (c) 2017 Cadence Design Systems, Inc.
#
# All rights reserved.
#
# Cadence Design Systems Proprietary and Confidential.
# -------------------------------------------------------

clear -all

# Read in HDL files
set RTL_PATH ../designs/cdc_design

analyze -sv ${RTL_PATH}/ndff_sync.v \
            ${RTL_PATH}/mux_sync.v \
            ${RTL_PATH}/reset_sync.v \
            ${RTL_PATH}/interruption_manager.v \
            ${RTL_PATH}/car.v \
            ${RTL_PATH}/shift_reg.v \
            ${RTL_PATH}/afifo.v \
            ${RTL_PATH}/fifo1.v \
            ${RTL_PATH}/control.v \
            ${RTL_PATH}/fsm.v \
            ${RTL_PATH}/bbox_module.v \
            ${RTL_PATH}/counter.v \
            ${RTL_PATH}/handshake.v \
            ${RTL_PATH}/ndff.v \
            ${RTL_PATH}/receiver_fsm.v \
            ${RTL_PATH}/receiver.v \
            ${RTL_PATH}/sender_fsm.v \
            ${RTL_PATH}/sender.v \
            ${RTL_PATH}/pulse_sync.v \
            ${RTL_PATH}/top_level.v

# Elaborate design
elaborate -bbox_m modreg_bank

# Setup clocks and clock association of ports
clock clock_control1
clock clock_control2
clock clock_fsm
clock clock_fsm clock_fsm_aux 2 1

# Clock rating for primary input ports
clock -rate {en_control clock_control_sel load_data write_on_fifo data_in change_fsm_state control_sig conv_br1 conv_br2 hshake_data_in in_reg1 control_data} clock_control1
clock -rate {en_fsm proc_int_code proc_int_control output_valid reg_mode reg_addr reg_wdata reset_n_fsm} clock_fsm
clock -rate counter_en clock_fsm_aux

# Clock rating for black-box output ports
clock -rate u_regbank.prdata_o clock_fsm

# Clock rating for black-box input ports
check_cdc -clock_domain -port {u_regbank.paddr_i} -clock_signal clock_control1
check_cdc -clock_domain -port {u_regbank.penable_i} -clock_signal clock_control1
check_cdc -clock_domain -port {u_regbank.pmodsel_i} -clock_signal clock_control1
check_cdc -clock_domain -port {u_regbank.pwdata_i} -clock_signal clock_control1
check_cdc -clock_domain -port {u_regbank.pwrite_i} -clock_signal clock_control1

# Reset
reset ~reset_n_control1 ~reset_n_control2 ~reset_n_fsm

assert {@(posedge clock_fsm) disable iff (!reset_n_fsm) counter_en |=> ##2 control_block.count_out_control == $past(FSM_block.count_out_fsm,2)} -name counters_equal_2_cycles_apart

#Controlling inputs
assume !control_sig -bound 1 -env
assume -env conv_br1
assume -env {$changed({FSM_block.buffer_lsw_in_reg}) |-> ($onehot({FSM_block.buffer_lsw_in_reg} ^ $past ({FSM_block.buffer_lsw_in_reg})))} 

# Signal configuration
check_cdc -signal_config -add_constant {{en_fsm 1}}
check_cdc -signal_config -add_constant {{en_control 1}}
check_cdc -signal_config -add_constant {{inp1 1}}
check_cdc -signal_config -add_constant {{in_reg1_sel 1}}
check_cdc -signal_config -add_constant {{clock_control_sel 1}}
check_cdc -signal_config -add_static {{conv_br1_reg}}

# Define rule severity
check_cdc -check -severity {fatal {no_scheme}} 
check_cdc -check -severity {error {cdc_pair_logic sync_chain_logic}} 
check_cdc -check -severity {warning {cdc_pair_fanout sync_chain_fanout}}

# Find clock domains
check_cdc -clock_domain -find

# Join clock domains
check_cdc -clock_domain -join jg_clocks_and_resets.clk1_div_reg -into jg_clock_control1
check_cdc -clock_domain -join jg_clock_fsm_aux -into jg_clock_fsm

# Find CDC pairs
check_cdc -pair -find

# Add instance-based user-defined FIFO scheme
check_cdc -scheme -add FIFO -map {{Wfull ctrl2fsm_fifo_sync.wfull} {Rempty ctrl2fsm_fifo_sync.rempty} {Winc ctrl2fsm_fifo_sync.winc} {Rinc ctrl2fsm_fifo_sync.rinc} {Wptr ctrl2fsm_fifo_sync.write_control.wptr} {Rptr ctrl2fsm_fifo_sync.read_control.rptr} {Wdata ctrl2fsm_fifo_sync.wdata} {Rdata ctrl2fsm_fifo_sync.rdata}}

# Find synchronizers and run structural checks
check_cdc -scheme -find

# Add manual waiver
check_cdc -waiver -add -filter [check_cdc -filter -add -violation Pair -source_unit reg_addr -destination_unit {u_regbank\.paddr_i} -source_clock clock_fsm -destination_clock clock_control1 -check no_scheme] -comment {Input to be synchronized externally}
check_cdc -waiver -add -filter [check_cdc -filter -add -violation Pair -source_unit reg_wdata -destination_unit {u_regbank\.pwdata_i} -source_clock clock_fsm -destination_clock clock_control1 -check no_scheme] -comment {Input to be synchronized externally}

# Add user-defined conditional waiver
set filter_id_pair [check_cdc -filter -add -violation Pair -source_unit reg_mode -destination_unit {u_regbank\.pmodsel_i} -source_clock clock_fsm -destination_clock clock_control1 -check no_scheme]
set waiver_id_pair [check_cdc -waiver -add -comment conditional_waiver_safe -filter $filter_id_pair -expression {write_en == control_block.write_en}]

# Find convergences
check_cdc -group -find

# Validate waivers
check_cdc -waiver -generate
check_cdc -waiver -prove

# Accessing CDC database for checking auto-waiver reason
set waivers [check_cdc -list waivers]
foreach key [dict keys $waivers] {
    set waiver_type [dict get $waivers $key {Waiver Type}];
        if {$waiver_type == "Auto"} {
            set waiverId [dict get $waivers $key {Id}]
            check_cdc -waiver -why $waiverId
        }
}

# Functional checks
check_cdc -protocol_check -generate
check_cdc -protocol_check -prove
check_cdc -signal_config -prove

set PROJ_DIR [get_proj_dir]
# Export functional checks for simulation
check_cdc -protocol_check -export -file $PROJ_DIR/cdc_properties.svp -force
check_cdc -export -type signal_config_property -file $PROJ_DIR/signal_config_checks.svp -force
check_cdc -export -type waiver_cond_property -file $PROJ_DIR/waiver_condition_checks.svp -force

# Metastability injection in Formal
prove -task {<embedded>}
check_cdc -metastability -inject
check_cdc -metastability -prove

# Export control file for metastability injection in simulation
check_cdc -metastability -export -time_window 1

# Reset analysis
check_cdc -reset -find

# Report Generation
file mkdir $PROJ_DIR/reports
check_cdc -report pairs -file $PROJ_DIR/reports/pairs.csv -force
check_cdc -report violations -file $PROJ_DIR/reports/violations.csv -force
check_cdc -report domains -file $PROJ_DIR/reports/clock_domains.csv -force
check_cdc -report rules -file $PROJ_DIR/reports/path_rules.csv -force
check_cdc -report filters -file $PROJ_DIR/reports/userdef_filters.csv -force
check_cdc -report signal_config -file $PROJ_DIR/reports/const_values.csv -force
check_cdc -report signoff -file $PROJ_DIR/reports/signoff.csv -force
puts "Successfully generated all reports in \'$PROJ_DIR/reports\' folder.\n"
