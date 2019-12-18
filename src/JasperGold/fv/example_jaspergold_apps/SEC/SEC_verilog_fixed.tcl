# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------
clear -all

# Analyze design under verification files
set SPEC_RTL_PATH ../designs/uart_design/verilog_sva/source/design
set IMP_RTL_PATH ../designs/uart_design/verilog_sva/source/imp_design
set IMP_FIXED_RTL_PATH ../designs/uart_design/verilog_sva/source/imp_fixed_design

check_sec -setup -spec_top uart_top \
            -imp_top uart_top \
            -spec_analyze "-sv -f ${SPEC_RTL_PATH}/sec_spec.vfile" \
            -imp_analyze  "-sv -f ${IMP_FIXED_RTL_PATH}/sec_imp_fixed.vfile" \
            -spec_elaborate_opts "-bbox_m uart_tfifo" \
            -imp_elaborate_opts "-bbox_m uart_tfifo" 


# Define clocks 
clock wb_clk_i
clock -rate wb_cyc_i  wb_clk_i
clock -rate wb_stb_i  wb_clk_i
clock -rate wb_dat_i  wb_clk_i
clock -rate wb_we_i   wb_clk_i
clock -rate wb_sel_i  wb_clk_i
clock -rate wb_adr_i  wb_clk_i

# Define reset
reset wb_rst_i 

# Instruct SEC to automatically map uninitialized registers
check_sec -auto_map_reset_x_values on


# Define assumptions 


# Check for mapping issues
check_sec -interface

# SEC App automatically generates mapping pairs and provides flexibility to
# allows users to manipulate mapping relationships explicitly.
check_sec -map -spec {wb_adr_i[4:0]} -imp {uart_top_imp.wb_address_i[4:0]} -respect_connections_during_reset -global

# Generate verification environment
check_sec -gen

set_prove_time_limit 30s; #A very small prove time limit is used here for quick demo purpose.
check_sec -prove

# Run SignOff and waive off X signals and undrivens
check_sec -signoff -waive_category x_signals_and_undrivens



