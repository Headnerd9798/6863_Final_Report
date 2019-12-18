# Read DUT with embedded assertions
analyze -vhdl \
    ./design/fifo_package.vhd \
    ./design/fifo_funct.vhd \
    ./design/fifo_configure.vhd \
    ./design/fifo_components.vhd \
    ./design/fifo.vhd

# Read requirements with jasper_datapath
analyze -vhdl -req \
  ./jasper_req/FIFO_datapath.vhd

elaborate -bbox_a 512 -vhdl

connect FIFO_datapath req \
  -connect clk       clk \
  -connect rstN      hresetn \
  -connect valid_in  fifo_write \
  -connect valid_out fifo_read \
  -connect data_in   fifo_datain \
  -connect data_out  fifo_dataout

# Setup verification environment
clock  clk
reset  {hresetn = '0'}
assume -env {fifo_reset = '0'}

task -set {<req.dp_PACKET_SANITY>}
assume {not((fifo_empty_s = "0") and (fifo_read = '0'))}

# Prevent overflow and underflow conditions
assume -env {not((fifo_empty_s = "1") and (fifo_read = '1'))}
assume -env {not((fifo_full_s = "1") and (fifo_write = '1'))}

set_engine_mode engineG
prove -all


# -------------------------------------------------------
# Copyright (c) 2011 Jasper Design Automation, Inc.
#
# All rights reserved.
#
# Jasper Design Automation Proprietary and Confidential.
# -------------------------------------------------------

