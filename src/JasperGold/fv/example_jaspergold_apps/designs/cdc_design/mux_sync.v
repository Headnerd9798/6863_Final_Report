// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module mux_sync #(
parameter DSIZE = 32
)
(
    input                   clk,
    input                   rst_n,
    input       [DSIZE-1:0] data_in,
    input                   enable,
    output      [DSIZE-1:0] data_out
);

reg [DSIZE-1:0] data_sync;
reg en1,en2;

//Control Path
always @ (posedge clk)
    if (~rst_n) begin
        en1 <= 1'b0;
        en2 <= 1'b0;
    end
    else begin
        en1 <= enable;
        en2 <= en1;
    end

//DataPath
always @ (posedge clk, negedge rst_n)
    if (~rst_n)
        data_sync <= {DSIZE{1'b0}};
    else if (en2)
        data_sync <= data_in;

assign data_out = data_sync;
endmodule
