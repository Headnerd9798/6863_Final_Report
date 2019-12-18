# ----------------------------------------
#  Copyright (C) 2014 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

# Analyze design under verification files
set RTL_PATH ../designs/spv_design/vhdl

analyze -vhdl -f $RTL_PATH/hash.f
analyze -sv $RTL_PATH/sva/hash_checker.sv
 
# Elaborate design
elaborate -top hash -vhdl

# Set up proof environment
clock clk
reset "not rst_n"

stopat otp_key custom_key
stopat hash_core.out_hash

# Use SPV to auto-generate SPV assertions

# Verify secure information will never be read from the design
# e.g. data on the signals otp_key and custom_key never goes to
#      signal s_rdata while s_secure is low
check_spv -create \
          -from otp_key \
          -to s_rdata \
          -to_precond {NOT s_secure}

check_spv -create \
          -from custom_key \
          -to s_rdata \
          -to_precond {s_req AND (NOT s_write) AND s_ack AND (NOT s_secure) }

# Run proof
check_spv -prove

# Debug failure
visualize -violation -property <embedded>::spv_prop:1 -new_window 

