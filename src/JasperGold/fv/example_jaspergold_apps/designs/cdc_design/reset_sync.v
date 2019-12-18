// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module rst_sync(clk, async_rst_n, rst_out);
input clk, async_rst_n;
output reg rst_out;
reg rst_out_meta;

always @(posedge clk or negedge async_rst_n)
begin
    if (!async_rst_n) {rst_out, rst_out_meta} <= 2'b0;
    else              {rst_out, rst_out_meta} <= {rst_out_meta, 1'b1};
end
endmodule
