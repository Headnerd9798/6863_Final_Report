# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright
#  laws of the United States.
# ----------------------------------------

set CSR_MAP uart_top_JasperCSR.csv

# Analyze design under verification files
set RTL_PATH ../designs/uart_design/verilog_sva/source/design
set PROP_PATH ../designs/uart_design/verilog_sva/source/properties

analyze +define+DATA_BUS_WIDTH_8 -sv +incdir+${RTL_PATH} \
       ${RTL_PATH}/uart_top.v \
       ${RTL_PATH}/uart_debug_if.v \
       ${RTL_PATH}/uart_receiver.v \
       ${RTL_PATH}/uart_regs.v \
       ${RTL_PATH}/uart_sync_flops.v \
       ${RTL_PATH}/uart_tfifo.v \
       ${RTL_PATH}/uart_transmitter.v \
       ${RTL_PATH}/uart_wb.v \
       ${RTL_PATH}/uart_rfifo.v \
       ${RTL_PATH}/raminfr.v

# Analyze property files
analyze -sv +incdir+${RTL_PATH} \
       ${PROP_PATH}/wishbone_cons.sv

# Connect the Jasper CSR PA
analyze -sv09 jasper_CSR_PA_inst.sv

# Elaborate design
elaborate -top uart_top

# Load the CSR Address Map
check_csr -load $CSR_MAP -instance i_jasper_csr.jasper_csr_checker0 -auto_hr_info

# Set up Clocks and Resets
clock wb_clk_i
reset wb_rst_i -non_resettable_regs 0

# Setup proof environment
task -create IF_CONS -source_task <embedded> -copy_assumes
task -set CSR
task -link IF_CONS

set_engine_mode {Ht N}
set_prove_time_limit 30s

# Prove CSR properties
check_csr -prove

# Report proof results
report
