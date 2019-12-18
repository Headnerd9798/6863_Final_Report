# Analyze DUV files
analyze -vhdl \
    ./design/ua_control.vhd \
    ./design/ua_counter.vhd \
    ./design/ua_flags_fix.vhd \
    ./design/ua_set_par_conv.vhd \
    ./design/ua_start_detect.vhd \
    ./design/universal_asynchronous_receiver.vhd

# Analyze requirements files
analyze -vhdl -req {./jasper_req/datapath.vhd}

# Elaborate design and properties
elaborate -bbox false -vhdl -top {uar}

connect datapath dp \
  -connect {clk}       {clk}  \
  -connect {rstN}      {not gl_reset}  \
  -connect {tx_error}  {dError}  \
  -connect {valid_in}  {count8}  \
  -connect {data_in}   {dIn} \
  -connect {valid_out} {dReady}  \
  -connect {data_out}  {dOut}

clock {clk}
reset {gl_reset = '1'}

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

