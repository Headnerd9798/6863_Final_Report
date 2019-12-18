module fifo (
  clk, hresetn,
  fifo_reset,
  fifo_write,
  fifo_read,
  fifo_count,
  fifo_full,
  fifo_hfull,
  fifo_empty,
  fifo_hempty,
  fifo_datain,
  fifo_dataout
);
input         clk, hresetn;
input         fifo_reset;
input         fifo_write;
input         fifo_read;
output [3:0]  fifo_count;
output        fifo_full;
output        fifo_hfull;
output        fifo_empty;
output        fifo_hempty;
input  [31:0] fifo_datain;
output [31:0] fifo_dataout;

parameter fifohempty_level = 1;
parameter fifohfull_level = 7;
parameter fifo_length = 8;

wire          fifo_full_s, fifo_empty_s;
wire   [3:0]  fifo_count_s;
reg    [3:0]  rptr, wptr;
reg    [31:0] fifo [fifo_length-1:0];

always @(posedge clk or negedge hresetn) begin
  if (~hresetn) begin
    wptr <= 4'd0;
  end
  else begin
    if (fifo_reset) begin
      wptr <= 4'd0;
    end
    else if (fifo_write) begin
      fifo[wptr[2:0]] <= fifo_datain;
      wptr <= wptr + 4'd1;
    end
  end
end

always @(posedge clk or negedge hresetn) begin
  if (~hresetn) begin
    rptr <= 4'd0;
  end
  else begin
    if (fifo_reset) begin
      rptr <= 4'd0;
    end
    else if (fifo_read) begin
      rptr <= rptr + 4'd1;
    end
  end
end

assign fifo_dataout = fifo[rptr[2:0]];

assign fifo_count_s = wptr - rptr;
	
assign fifo_full_s  = (fifo_count_s==fifo_length);
assign fifo_empty_s = (fifo_count_s==4'd0);

assign fifo_hfull   = (fifo_count_s>=fifohfull_level);
assign fifo_hempty  = (fifo_count_s<=fifohempty_level);				
assign fifo_full    = fifo_full_s;
assign fifo_empty   = fifo_empty_s;
assign fifo_count   = fifo_count_s;

endmodule // fifo


// -------------------------------------------------------
// Copyright (c) 2000 Jasper Design Automation, Inc.
//
// All rights reserved.
//
// Jasper Design Automation Proprietary and Confidential.
// -------------------------------------------------------

