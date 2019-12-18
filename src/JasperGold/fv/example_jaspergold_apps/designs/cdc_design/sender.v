// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module sender(clk_s, reset_s, datain, dataout, ack_in, start, ready, req_out);
input clk_s, reset_s;
input [7:0] datain;
input ack_in; //Acknowledge from receiver
input start; // Start signal for data transfer
output reg [7:0] dataout;
output ready; // Signal indicating sender is idle
output req_out; // Request to receiver for data transfer

wire send_ctrl;
wire ack_sync_out;

ndff ack_sync(.clk(clk_s), .reset(reset_s), .in_async(ack_in), .out_sync(ack_sync_out));

sender_fsm fsm_unit (.clk(clk_s), .reset(reset_s), .start(start), .ack_sync(ack_sync_out), .ready(ready), .req_out(req_out), .send_ctrl(send_ctrl));

//Data bus handling
always @(posedge clk_s or negedge reset_s)
begin
    if (~reset_s)
        dataout <= 8'b0;
    else
        dataout <= send_ctrl ? datain : dataout;
end

endmodule
