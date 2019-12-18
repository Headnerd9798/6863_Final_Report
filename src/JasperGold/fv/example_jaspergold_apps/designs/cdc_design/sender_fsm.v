// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module sender_fsm (clk, reset, start, ack_sync, ready, req_out, send_ctrl);

input clk, reset;
input start;
input ack_sync; // synchronized version of ack from receiver
output reg ready;
output req_out; // Request out to receiver
output reg send_ctrl; // Data change  qualifier

localparam IDLE   = 2'b00,
           S_REQ1 = 2'b01,
           S_REQ0 = 2'b10;

reg [1:0] state_reg, state_next;
reg req_buf_reg, req_buf_next;

// State register and output buffer
always @(posedge clk or negedge reset)
begin
    if (reset == 1'b0) begin
        state_reg <= IDLE;
        req_buf_reg <= 1'b0;
    end 
    else begin
        state_reg <= state_next;
        req_buf_reg <= req_buf_next;
    end
end

// Next state logic
always @(state_reg or start or ack_sync)
begin
    ready <= 1'b0;
    send_ctrl <= 1'b0;
    state_next <= state_reg;
    case (state_reg)
    IDLE : begin
        ready <= 1'b1;
        if (start == 1'b1)
             state_next <= S_REQ1;
    end
    S_REQ1 : begin
        if (ack_sync == 1'b1) begin
             state_next <= S_REQ0;
             send_ctrl <= 1'b1;
        end
    end
    S_REQ0 : begin
        if (ack_sync == 1'b0)
            state_next <= IDLE;
    end
    endcase
end

// Look Ahead output logic
always @(state_next)
begin
    case (state_next)
        IDLE : begin
            req_buf_next = 1'b0;
        end
        S_REQ1 : begin
            req_buf_next = 1'b1;
        end
        S_REQ0 : begin
            req_buf_next = 1'b0;
        end
    endcase
end

assign req_out = req_buf_reg;

endmodule
