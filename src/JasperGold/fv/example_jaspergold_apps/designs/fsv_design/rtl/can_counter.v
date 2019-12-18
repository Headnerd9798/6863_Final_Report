// -------------------------------------------------------
// Copyright (c) 2018 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

// Verilog HDL for gdglib, can_counter _functional

module can_counter( clk, reset, load, count, dispense, empty);

    input clk, reset, load, dispense;
    input [7:0] count;
    output empty;

    reg [7:0] left; 

    wire empty;
	
    assign empty = !left;

    always @(posedge clk)
    if (reset)
        left <= 0;
    else if (load && !dispense)
        left <= count;
    else if(!load && dispense)
        left <= left - 8'h1;

endmodule
