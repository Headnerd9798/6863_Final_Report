///////////////////////////////////////////////////////////////////////////////
//
//               Copyright 2006-2016 Mentor Graphics Corporation
//                          All Rights Reserved.
//  
//             THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY
//           INFORMATION WHICH IS THE PROPERTY OF MENTOR GRAPHICS 
//          CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE
//                                 TERMS.
//
///////////////////////////////////////////////////////////////////////////////

module arbiter_checker_sva(clk, rst, req, gnt);
input       clk, rst;
input [4:0] req, gnt;

default clocking c0 @(posedge clk); endclocking

// Single-grant check
arb_single_grant: assert property (disable iff(rst)  ($onehot(gnt) || gnt == 'b0));

// Known-grant checks
arb_known_grant_4: assert property (disable iff(rst) gnt[4] |-> $past(req[4],1));
arb_known_grant_3: assert property (disable iff(rst) gnt[3] |-> $past(req[3],1));
arb_known_grant_2: assert property (disable iff(rst) gnt[2] |-> $past(req[2],1));
arb_known_grant_1: assert property (disable iff(rst) gnt[1] |-> $past(req[1],1));
arb_known_grant_0: assert property (disable iff(rst) gnt[0] |-> $past(req[0],1));

// Coverage: grant asserted
arb_cover_grant_4: cover property (~rst & gnt[4]);
arb_cover_grant_3: cover property (~rst & gnt[3]);
arb_cover_grant_2: cover property (~rst & gnt[2]);
arb_cover_grant_1: cover property (~rst & gnt[1]);
arb_cover_grant_0: cover property (~rst & gnt[0]);

endmodule
