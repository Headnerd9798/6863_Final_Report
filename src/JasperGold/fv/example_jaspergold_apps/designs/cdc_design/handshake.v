// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module hsync (srst, drst, sclk, dclk, start, ready, din, dout);
input srst, drst, sclk, dclk;
input start;
input [7:0] din;
output ready;
output [7:0] dout;

wire req;
wire ack;
wire [7:0] data;

receiver rx_block (.clk_r(dclk), 
                  .reset_r(drst), 
                  .req_in(req), 
                  .datain (data),
                  .dataout (dout),
                  .ack_out(ack));

sender tx_block (.clk_s(sclk), 
                 .reset_s(srst), 
                 .datain(din), 
                 .dataout(data),
                 .ack_in(ack), 
                 .start(start),
                 .ready(ready),
                 .req_out(req));
endmodule
