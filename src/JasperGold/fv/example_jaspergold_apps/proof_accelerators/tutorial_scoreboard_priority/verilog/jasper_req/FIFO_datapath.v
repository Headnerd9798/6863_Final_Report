module FIFO_datapath (
  clk,
  rstN,
  valid_in,  // push strobe, active high
  valid_out, // pop strobe, active high
  data_in,
  data_out
);
input         clk, rstN;
input         valid_in;
input         valid_out;
input  [31:0] data_in;
input  [31:0] data_out;

  jasper_scoreboard_priority #(8,5,32) dp (
    .clk1(clk),
    .clk2(clk),
    .rst1N(rstN),
    .rst2N(rstN),

    .incoming_vld(valid_in),
    .incoming_eop(valid_in),
    .incoming_sop(valid_in),
    .incoming_data(data_in),

    .outgoing_sop(valid_out),
    .outgoing_eop(valid_out),
    .outgoing_vld(valid_out),
    .outgoing_data(data_out),

    .port_valid(1'b1),
    .duplicated(1'b0),
    .priority_in(1'b0)
  );

endmodule // FIFO_datapath


// -------------------------------------------------------
// Copyright (c) 2000 Jasper Design Automation, Inc.
//
// All rights reserved.
//
// Jasper Design Automation Proprietary and Confidential.
// -------------------------------------------------------

