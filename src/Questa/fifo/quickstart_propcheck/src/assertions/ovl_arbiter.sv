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
module arbiter_checker_ovl(clk, rst, req, gnt);

	input       clk, rst;
	input [4:0] req, gnt;

	// OVL ASSERTIONS
	// Single-grant check (using ovl_bits)
	wire [2:0] bits_single_grant_fire;
	ovl_bits #( .width(5), .min(0), .max(1)) bits_single_grant (
		.clock(clk), 
		.reset(!rst), 
		.enable(1'b1), 
		.test_expr(gnt), 
		.fire(bits_single_grant_fire));
	// Single-grant check (using ovl_zero_one_hot)
	wire [2:0] arb_single_grant_fire;
	ovl_zero_one_hot #(.width(5), .coverage_level(4)) arb_single_grant (
		.clock(clk), 
		.reset(!rst), 
		.enable(1'b1), 
		.test_expr(gnt), 
		.fire(arb_single_grant_fire));
	// Known-grant checks
	reg [4:0] reqd;
	always @(posedge clk) reqd <= req;
	wire [2:0] arb_known_grant_4_fire;
	wire [2:0] arb_known_grant_3_fire;
	wire [2:0] arb_known_grant_2_fire;
	wire [2:0] arb_known_grant_1_fire;
	wire [2:0] arb_known_grant_0_fire;
	ovl_implication arb_known_grant_4 (
		.clock(clk), .reset(!rst), .enable(1'b1), .antecedent_expr(gnt[4]), .consequent_expr(reqd[4]), .fire(arb_known_grant_4_fire));
	ovl_implication arb_known_grant_3 (
		.clock(clk), .reset(!rst), .enable(1'b1), .antecedent_expr(gnt[3]), .consequent_expr(reqd[3]), .fire(arb_known_grant_3_fire));
	ovl_implication arb_known_grant_2 (
		.clock(clk), .reset(!rst), .enable(1'b1), .antecedent_expr(gnt[2]), .consequent_expr(reqd[2]), .fire(arb_known_grant_2_fire));
	ovl_implication arb_known_grant_1 (
		.clock(clk), .reset(!rst), .enable(1'b1), .antecedent_expr(gnt[1]), .consequent_expr(reqd[1]), .fire(arb_known_grant_1_fire));
	ovl_implication arb_known_grant_0 (
		.clock(clk), .reset(!rst), .enable(1'b1), .antecedent_expr(gnt[0]), .consequent_expr(reqd[0]), .fire(arb_known_grant_0_fire));

endmodule

