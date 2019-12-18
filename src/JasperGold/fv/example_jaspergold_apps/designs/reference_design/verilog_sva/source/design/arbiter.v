//---------------------------------------------------------------------------//
//                                                                           //
//  Module:  arbiter                                                         //
//                                                                           //
//  Version: 13 July 2006                                                    //
//---------------------------------------------------------------------------//

//************************************************************************
//
//  Copyright (C) 2017 Cadence Design Systems, Inc. All Rights
//  Reserved.  Unpublished -- rights reserved under the copyright laws of
//  the United States.
//
//  The content of this file is owned by Jasper Design Automation, Inc.
//  and may be used only as authorized in the license agreement
//  controlling such use. No part of these materials may be reproduced,
//  transmitted, or translated, in any form or by any means, electronic,
//  mechanical, manual, optical, or otherwise, without prior written
//  permission of Jasper Design Automation, or as expressly provided by
//  the license agreement. These materials are for information and
//  instruction purposes.
//
//  For technical assistance please send email to support@jasper-da.com.
//
// ***********************************************************************

`define HI_PRI_CNT 9'd500

module arbiter (
  clk, rstN,
  int_ready,
  int_valid,
  trans_started,
  ig_req,
  ig_sel
);

input  clk, rstN;	         // Clock and reset (active low)
input  int_ready;
input  int_valid;
input  trans_started;
input  [3:0] ig_req;
output [1:0] ig_sel;

// Request for all ports
wire [3:0] req;

// When the arbiter is ready to sample the next request
wire sample_transfer_ready;
wire sample_ready;

// Generated sample timer counter
reg [1:0] sample_timer_cnt;
// Sampling signals based on sampling counter
wire sample_hipri;
wire sample_pgrant;
wire sample_grant;

// Enable for round-robin shift register
reg last_phase;

// Sampled request until grant
reg [3:0] req_r;

// Counters to increase priority when duration since the last transfer
// from respective port reaches HI_PRI_CNT limit
reg [8:0] port_idle_cnt0;
reg [8:0] port_idle_cnt1;
reg [8:0] port_idle_cnt2;
reg [8:0] port_idle_cnt3;

// High priority level
reg [3:0] hi_pri;

// Determine round-robin port
reg [3:0] shift;
// Delayed version of shift
reg [3:0] shift_d;

// Current port for grant
reg [1:0] current_port;
// Next port for grant
reg [1:0] next_port;

// Req based on port idle priority
wire [3:0] pri_req;

// Round-robin priority of each port
reg [1:0] sel0;
reg [1:0] sel1;
reg [1:0] sel2;
reg [1:0] sel3;

// Output of the round-robin port selector
reg [3:0] req_rr;
// Delayed version of req_rr
reg [3:0] req_rr_d;

// Generate grant
reg [3:0] gnt;

// Generate port select for control/address/data
reg [1:0] ig_sel;

assign req = ig_req;

assign sample_transfer_ready = sample_ready & ~last_phase
                              & (req != 4'b0) & ~trans_started
                              & ~int_valid;

always @(posedge clk) begin
  if (!rstN)                      sample_timer_cnt <= 2'd3;
  else if (sample_transfer_ready) sample_timer_cnt <= 2'd0;
  else if (~sample_ready && ~sample_pgrant)
                                  sample_timer_cnt <= sample_timer_cnt + 2'd1;
  else if (sample_pgrant && int_ready)
                                  sample_timer_cnt <= sample_timer_cnt + 2'd1;
end

assign sample_hipri  = (sample_timer_cnt == 2'd0); // Check high priority
assign sample_pgrant = (sample_timer_cnt == 2'd1); // Cycle before grant
assign sample_grant  = (sample_timer_cnt == 2'd2); // Generate grant
assign sample_ready  = (sample_timer_cnt == 2'd3); // Grant issued

always @(posedge clk or negedge rstN) begin
  if (!rstN) last_phase <= 1'b0;
  else       last_phase <= sample_grant;
end

always @(posedge clk or negedge rstN) begin
  if (!rstN)                      req_r <= 4'b0000;
  else if (sample_transfer_ready) req_r <= req;
end

always @(posedge clk or negedge rstN) begin
  if (!rstN) begin
    port_idle_cnt0 <= 9'b0;
    port_idle_cnt1 <= 9'b0;
    port_idle_cnt2 <= 9'b0;
    port_idle_cnt3 <= 9'b0;
    hi_pri <= 4'b0;
  end
  else begin
    if(gnt[0]) begin
      hi_pri[0] <= 1'b0;
      port_idle_cnt0 <= 9'b0;
    end
    else begin
      if (port_idle_cnt0 == `HI_PRI_CNT) hi_pri[0] <= 1'b1;
      port_idle_cnt0 <= port_idle_cnt0 + 9'b1;
    end
    if(gnt[1]) begin
      hi_pri[1] <= 1'b0;
      port_idle_cnt1 <= 9'b0;
    end
    else begin
      if (port_idle_cnt1 == `HI_PRI_CNT) hi_pri[1] <= 1'b1;
      port_idle_cnt1 <= port_idle_cnt1 + 9'b1;
    end
    if(gnt[2]) begin
      hi_pri[2] <= 1'b0;
      port_idle_cnt2 <= 9'b0;
    end
    else begin
      if (port_idle_cnt2 == `HI_PRI_CNT) hi_pri[2] <= 1'b1;
      port_idle_cnt2 <= port_idle_cnt2 + 9'b1;
    end
    if(gnt[3]) begin
      hi_pri[3] <= 1'b0;
      port_idle_cnt3 <= 9'b0;
    end
    else begin
      if (port_idle_cnt3 == `HI_PRI_CNT) hi_pri[3] <= 1'b1;
      port_idle_cnt3 <= port_idle_cnt3 + 9'b1;
    end
  end
end

wire hipri_req = |(req_r & hi_pri);
		
assign pri_req[0] = sample_hipri ?
  (hipri_req ? (req_r[0] & hi_pri[0]) : req_r[0]) : 1'b0;
assign pri_req[1] = sample_hipri ?
  (hipri_req ? (req_r[1] & hi_pri[1]) : req_r[1]) : 1'b0;
assign pri_req[2] = sample_hipri ?
  (hipri_req ? (req_r[2] & hi_pri[2]) : req_r[2]) : 1'b0;
assign pri_req[3] = sample_hipri ?
  (hipri_req ? (req_r[3] & hi_pri[3]) : req_r[3]) : 1'b0;

always @(sel0 or sel1 or sel2 or sel3 or pri_req) begin
  if (pri_req[sel0]) req_rr[0] = 1'b1;
  else               req_rr[0] = 1'b0;
  if (pri_req[sel1]) req_rr[1] = 1'b1;
  else               req_rr[1] = 1'b0;
  if (pri_req[sel2]) req_rr[2] = 1'b1;
  else               req_rr[2] = 1'b0;
  if (pri_req[sel3]) req_rr[3] = 1'b1;
  else               req_rr[3] = 1'b0;
end

wire [3:0] rr_shift = shift_d;

always @(posedge clk or negedge rstN) begin
  if (!rstN) req_rr_d <= 4'b0000;
  else       req_rr_d <= req_rr;
end

always @(posedge clk or negedge rstN) begin
  if (!rstN)            current_port <= 2'b00;
  else if (!last_phase) current_port <= next_port;
end

always @(sel0 or sel1 or sel2 or sel3 or current_port or req_rr_d) begin
  if      (req_rr_d[0]) next_port = sel0;
  else if (req_rr_d[1]) next_port = sel1;
  else if (req_rr_d[2]) next_port = sel2;
  else if (req_rr_d[3]) next_port = sel3;
  else                  next_port = current_port;
end

always @(posedge clk or negedge rstN) begin
  if (!rstN)            shift_d <= 4'h0;
  else if (!last_phase) shift_d <= shift;
end

always @(shift_d or req_rr_d) begin
  if      (req_rr_d[0]) shift[3:0] = 4'b1111;
  else if (req_rr_d[1]) shift[3:0] = 4'b1110;
  else if (req_rr_d[2]) shift[3:0] = 4'b1100;
  else if (req_rr_d[3]) shift[3:0] = 4'b1000;
  else                  shift[3:0] = shift_d;
end

always @(posedge clk or negedge rstN) begin
  if (!rstN) begin
                     sel0 <= 2'b00;
                     sel1 <= 2'b01;
                     sel2 <= 2'b10;
                     sel3 <= 2'b11;
  end
  else if (last_phase && int_ready) begin
    if (rr_shift[0]) sel0 <= sel1;
    if (rr_shift[1]) sel1 <= sel2;
    if (rr_shift[2]) sel2 <= sel3;
    if (rr_shift[3]) sel3 <= current_port;
  end
end

always @(posedge clk or negedge rstN) begin
  if (!rstN) gnt <= 4'b0000;
  else begin
    if (sample_grant & (next_port == 2'b00))
             gnt[0] <= 1'b1;
    else     gnt[0] <= 1'b0;
    if (sample_grant & (next_port == 2'b01))
             gnt[1] <= 1'b1;
    else     gnt[1] <= 1'b0;
    if (sample_grant & (next_port == 2'b10))
             gnt[2] <= 1'b1;
    else     gnt[2] <= 1'b0;
    if (sample_grant & (next_port == 2'b11))
             gnt[3] <= 1'b1;
    else     gnt[3] <= 1'b0;
  end
end

always @(posedge clk or negedge rstN) begin
  if (!rstN) ig_sel <= 2'b00;
  else begin
    if (sample_grant) ig_sel <= next_port;
  end
end

endmodule // arbiter
