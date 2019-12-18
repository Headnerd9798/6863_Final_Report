// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module ndff_sync (
    input       clk,
    input       rst_n,
    input       data_in,
    output      data_out
);

reg data_meta,data_sync;

always @ (posedge clk,negedge rst_n)
    if (~rst_n) begin
        data_meta <= 1'b0;
        data_sync <= 1'b0;
    end
    else begin
        data_meta <= data_in;
        data_sync <= data_meta;
    end
assign data_out = data_sync;
endmodule
