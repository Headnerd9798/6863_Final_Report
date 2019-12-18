module datapath (
  clk, rstN,
  tx_error,
  valid_in,  data_in,
  valid_out, data_out
);

input       clk, rstN;
input       tx_error;
input       valid_in;
input       data_in;
input       valid_out;
input [7:0] data_out;

wire pkt_in;
wire pkt_out;
wire pkt_in_from_port;
wire [7:0] pkt_out_to_port;
wire polarity;

jasper_scoreboard_2 #(1, 8) dp
  ( .clk1(clk)
  , .clk2(clk)
  , .rst1N(rstN && ~tx_error)
  , .rst2N(rstN && ~tx_error)

  , .incoming_vld  (valid_in)
  , .incoming_data (data_in)

  , .outgoing_vld  ({8{valid_out}})
  , .outgoing_data (data_out)

  , .random_packet_selected (pkt_in)
  , .selected_packet_exits  (pkt_out)

  , .random_packet_selected_pport (pkt_in_from_port)
  , .selected_packet_exits_pport (pkt_out_to_port)

  , .polarity (polarity)
  );

endmodule // datapath


// -------------------------------------------------------
// Copyright (c) 2000 Jasper Design Automation, Inc.
//
// All rights reserved.
//
// Jasper Design Automation Proprietary and Confidential.
// -------------------------------------------------------

