// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module ndff(clk, reset, in_async, out_sync);

input clk, reset, in_async;
output reg out_sync;

reg out_sync_reg;

always @(posedge clk or negedge reset)
begin
    if (reset == 1'b0) begin
        out_sync_reg <= 1'b0;
        out_sync <= 1'b0;
    end 
    else begin
        out_sync_reg <= in_async;
        out_sync <= out_sync_reg;
    end
end

endmodule
        
    
