// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module receiver (clk_r, reset_r, req_in, datain, dataout, ack_out);

input clk_r, reset_r;
input req_in; // Request from sender
input [7:0] datain;
output reg [7:0] dataout;
output ack_out; // Acknowledge from receiver

wire recv_ctrl;
wire req_sync_out;

ndff req_sync (.clk(clk_r), .reset(reset_r), .in_async(req_in), .out_sync(req_sync_out));

receiver_fsm fsm_unit (.clk(clk_r), .reset(reset_r), .req_sync(req_sync_out), .ack_out(ack_out), .recv_ctrl(recv_ctrl));

//Data handling
always @(posedge clk_r or negedge reset_r)
begin
    if (~reset_r)
        dataout <= 8'b0;
    else
        dataout <= recv_ctrl ? datain : dataout;
end

endmodule
