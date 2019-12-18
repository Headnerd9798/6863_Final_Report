// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module siso (din ,clk ,dout );

output dout ;
reg dout ;

input din ;
input clk ;
//input reset ;

reg [2:0]s;

always @ (posedge clk) 
begin 
        s[0] <= din ;
        s[1] <= s[0] ;
        s[2] <= s[1] ;
        dout <= s[2]; 
end

endmodule
