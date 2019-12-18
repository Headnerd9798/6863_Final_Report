# Analyze DUV files
analyze -verilog {./design/universal_asynchronous_receiver_fix.v} ;

# Analyze requirements files
analyze -verilog -req {./jasper_req/datapath.v}

# Elaborate design and properties
elaborate -bbox false -top {uar}

connect datapath dp \
  -connect {clk}       {clk}       \
  -connect {rstN}      {~gl_reset} \
  -connect {tx_error}  {dError}    \
  -connect {valid_in}  {count8}    \
  -connect {data_in}   {dIn}       \
  -connect {valid_out} {dReady}    \
  -connect {data_out}  {dOut}

clock {clk}
reset {gl_reset}

# Disabling sanity checks since scoreboard reset is allowed
assert -disable <dp.dp_PACKET_INTEGRITY>::sanity_reset_activated
assert -disable <dp.dp_PACKET_INTEGRITY>::sanity_reset_toggle_once

set_engine_mode engineG

prove -all


# -------------------------------------------------------
# Copyright (c) 2011 Jasper Design Automation, Inc.
#
# All rights reserved.
#
# Jasper Design Automation Proprietary and Confidential.
# -------------------------------------------------------

