// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module receiver_fsm (clk, reset, req_sync, ack_out, recv_ctrl);

input clk, reset;
input req_sync; // Synchronized version of req_out from sender
output ack_out; //Acknowledge output from receiver
output reg recv_ctrl; // Data capture qualifier

localparam S_ACK0 = 1'b0,
           S_ACK1 = 1'b1;

reg state_reg, state_next;
reg ack_buf_reg, ack_buf_next;

// State register and output buffer
always @(posedge clk or negedge reset)
begin
    if (reset == 1'b0) begin
        state_reg <= S_ACK0;
        ack_buf_reg <= 1'b0;
    end
    else begin
        state_reg <= state_next;
        ack_buf_reg <= ack_buf_next;
    end
end

// Next state logic
always @(state_reg or req_sync)
begin
    state_next <= state_reg;
    recv_ctrl <= 1'b0;
    case (state_reg)
    S_ACK0 : begin
        if (req_sync == 1'b1) begin
            state_next <= S_ACK1;
            recv_ctrl <= 1'b1;
        end
    end
    S_ACK1 : begin
        if (req_sync == 1'b0)
            state_next <= S_ACK0;
    end
    endcase
end

// Look ahead output logic
always @(state_next)
begin
    case (state_next)
    S_ACK0 : begin
        ack_buf_next <= 1'b0;
    end
    S_ACK1 : begin
        ack_buf_next <= 1'b1;
    end
    endcase
end

assign ack_out = ack_buf_reg;

endmodule
