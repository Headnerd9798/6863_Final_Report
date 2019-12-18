# Read DUT with embedded assertions
analyze -verilog {./design/fifo.v}

# Read requirements with jasper_datapath
analyze -verilog -req \
  ./jasper_req/FIFO_datapath.v

elaborate -bbox_a 512

connect FIFO_datapath req \
  -connect clk       clk \
  -connect rstN      hresetn \
  -connect valid_in  fifo_write \
  -connect valid_out fifo_read \
  -connect data_in   fifo_datain \
  -connect data_out  fifo_dataout

# Setup verification environment
clock  clk
reset  {~hresetn}
assume -env {~fifo_reset}

task -set {<req.dp_PACKET_SANITY>}
assume {(~fifo_empty_s && ~fifo_read) == 1'b0}

# Prevent overflow and underflow conditions
assume -env {(fifo_empty && fifo_read) == 1'b0}
assume -env {(fifo_full && fifo_write) == 1'b0}

set_engine_mode engineG
prove -all


# -------------------------------------------------------
# Copyright (c) 2011 Jasper Design Automation, Inc.
#
# All rights reserved.
#
# Jasper Design Automation Proprietary and Confidential.
# -------------------------------------------------------

