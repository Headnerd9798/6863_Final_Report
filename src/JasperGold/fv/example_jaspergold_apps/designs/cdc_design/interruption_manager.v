// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module interruption_manager (
    input clk,
    input rst_n,
    input [2:0] i_code,
    input i_valid,
    output reg stop1,
    output reg stop2,
    output reg stop3
);

//Mux Sync gathering the data from the FSM
wire [2:0] interruption_code_s;
mux_sync #(3) msynchronizer (clk,rst_n,i_code,i_valid,interruption_code_s);

//Interruption control
always @ (posedge clk, negedge rst_n ) begin
    if (~rst_n) begin
        stop1 <= 1'b0;
        stop2 <= 1'b0;
        stop3 <= 1'b0;
    end
    begin
        case (interruption_code_s)
            3'd0: begin stop1 <= 1'b0; stop2 <= 1'b0; stop3 <= 1'b0; end
            3'd1: begin stop1 <= 1'b0; stop2 <= 1'b1; stop3 <= 1'b0; end
            3'd2: begin stop1 <= 1'b0; stop2 <= 1'b0; stop3 <= 1'b1; end
            3'd3: begin stop1 <= 1'b1; stop2 <= 1'b1; stop3 <= 1'b0; end
            3'd4: begin stop1 <= 1'b1; stop2 <= 1'b0; stop3 <= 1'b1; end
            3'd5: begin stop1 <= 1'b0; stop2 <= 1'b1; stop3 <= 1'b1; end
            3'd6: begin stop1 <= 1'b1; stop2 <= 1'b0; stop3 <= 1'b0; end
            3'd7: begin stop1 <= 1'b1; stop2 <= 1'b1; stop3 <= 1'b1; end
        endcase
    end
end
endmodule
