// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module counter (input clk, input rst_n, input en, output reg [7:0] out);
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      out <= 8'b00000000;
    else if (en)
      out <= out + 1'b1;
  end
endmodule
