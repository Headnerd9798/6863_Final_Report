//---------------------------------------------------------------------------//
//                                                                           //
//  Module:  top                                                             //
//                                                                           //
//  Description: 4-to-1 switch                                               //
//                                                                           //
//  Version: 13 July 2006                                                    //
//---------------------------------------------------------------------------//

//************************************************************************
//  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
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
// **********************************************************************

module top (
  clk, rstN,
  addr0, valid0, ready0, wr_rd0, rdata0, wdata0, size0,
  addr1, valid1, ready1, wr_rd1, rdata1, wdata1, size1,
  addr2, valid2, ready2, wr_rd2, rdata2, wdata2, size2,
  addr3, valid3, ready3, wr_rd3, rdata3, wdata3, size3,
  eg_datain, eg_ad_dataout, eg_valid, eg_ready
);

// Ingress interface
input clk, rstN;

// Ingress port address
input [6:0] addr0;
input [6:0] addr1;
input [6:0] addr2;
input [6:0] addr3;

// Ingress data valid
input valid0, valid1, valid2, valid3;

// Ingress data ready
output ready0, ready1, ready2, ready3;

// Ingress wr/rd - 1 for wr 0 for read
input wr_rd0, wr_rd1, wr_rd2, wr_rd3;

// Ingress write data
input [31:0] wdata0, wdata1, wdata2, wdata3;

// Ingress transfer size 0 for 1 byte,
// 1 for two bytes, 2 for three bytes, 3 for 4 bytes
input [1:0] size0, size1, size2, size3;

// Ingress read data
output [31:0] rdata0, rdata1, rdata2, rdata3;

// Egress Interface
input [7:0] eg_datain;
output eg_valid;
input eg_ready;
output [7:0] eg_ad_dataout;


// Connections
wire [1:0] ig_sel;

wire [6:0] addr0;
wire [6:0] addr1;
wire [6:0] addr2;
wire [6:0] addr3;
wire [6:0] addr;

wire [1:0] size0;
wire [1:0] size1;
wire [1:0] size2;
wire [1:0] size3;
wire [1:0] size;

wire [31:0] wdata0;
wire [31:0] wdata1;
wire [31:0] wdata2;
wire [31:0] wdata3;
wire [31:0] wdata;

wire [31:0] rdata0;
wire [31:0] rdata1;
wire [31:0] rdata2;
wire [31:0] rdata3;
wire [31:0] rdata;

wire [31:0] int2ig_data0;
wire [31:0] int2ig_data1;
wire [31:0] int2ig_data2;
wire [31:0] int2ig_data3;
wire [31:0] int2ig_data;

wire [1:0] int_size0;
wire [1:0] int_size1;
wire [1:0] int_size2;
wire [1:0] int_size3;
wire [1:0] int_size;

wire [38:0] int_addr_data0;
wire [38:0] int_addr_data1;
wire [38:0] int_addr_data2;
wire [38:0] int_addr_data3;
wire [38:0] int_addr_data;

wire int_read_write;
wire int_valid;
wire int_ready;
wire int_datavalid;
wire int_datardy;

wire [7:0] int2eg_data;
wire [7:0] eg2int_data;

wire eg_valid;
wire [7:0] eg_datain;
wire [7:0] eg_ad_dataout;


ingress ing0 (
  .clk(clk),
  .rstN(rstN),
  .rd_ready(rd_ready),
  .addr(addr0),
  .valid(valid0),
  .ready(ready0),
  .wr_rd(wr_rd0),
  .rdata(rdata0),
  .wdata(wdata0),
  .size(size0),
  .int_size(int_size0),
  .int2ig_data(int2ig_data0),
  .int_addr_data(int_addr_data0),
  .new_tran(new_tran0),
  .int_read_done(int_read_done0),
  .current_read_write(current_read_write0),
  .int_read_write(int_read_write0),
  .int_ready(int_ready0),
  .int_valid(int_valid0),
  .trans_started(trans_started0)
);

ingress ing1 (
  .clk(clk),
  .rstN(rstN),
  .rd_ready(rd_ready),
  .addr(addr1),
  .valid(valid1),
  .ready(ready1),
  .wr_rd(wr_rd1),
  .rdata(rdata1),
  .wdata(wdata1),
  .size(size1),
  .int_size(int_size1),
  .int2ig_data(int2ig_data1),
  .int_addr_data(int_addr_data1),
  .new_tran(new_tran1),
  .int_read_done(int_read_done1),
  .current_read_write(current_read_write1),
  .int_read_write(int_read_write1),
  .int_ready(int_ready1),
  .int_valid(int_valid1),
  .trans_started(trans_started1)
);

ingress ing2 (
  .clk(clk),
  .rstN(rstN),
  .rd_ready(rd_ready),
  .addr(addr2),
  .valid(valid2),
  .ready(ready2),
  .wr_rd(wr_rd2),
  .rdata(rdata2),
  .wdata(wdata2),
  .size(size2),
  .int_size(int_size2),
  .int2ig_data(int2ig_data2),
  .int_addr_data(int_addr_data2),
  .new_tran(new_tran2),
  .int_read_done(int_read_done2),
  .current_read_write(current_read_write2),
  .int_read_write(int_read_write2),
  .int_ready(int_ready2),
  .int_valid(int_valid2),
  .trans_started(trans_started2)
);

ingress ing3 (
  .clk(clk),
  .rstN(rstN),
  .rd_ready(rd_ready),
  .addr(addr3),
  .valid(valid3),
  .ready(ready3),
  .wr_rd(wr_rd3),
  .rdata(rdata3),
  .wdata(wdata3),
  .size(size3),
  .int_size(int_size3),
  .int2ig_data(int2ig_data3),
  .int_addr_data(int_addr_data3),
  .new_tran(new_tran3),
  .int_read_done(int_read_done3),
  .current_read_write(current_read_write3),
  .int_read_write(int_read_write3),
  .int_ready(int_ready3),
  .int_valid(int_valid3),
  .trans_started(trans_started3)
);

egress eg (
  .clk(clk),
  .rstN(rstN),
  .int2eg_data(int2eg_data),
  .eg2int_data(eg2int_data),
  .int_datavalid(int_datavalid),
  .int_datardy(int_datardy),
  .eg_datain(eg_datain),
  .eg_ad_dataout(eg_ad_dataout),
  .eg_valid(eg_valid),
  .eg_ready(eg_ready)
);

bridge brdg (
  .clk(clk),
  .rstN(rstN),
  .int_datavalid(int_datavalid),
  .int_datardy(int_datardy),
  .int2eg_data(int2eg_data),
  .eg2int_data(eg2int_data),
  .int_size(int_size),
  .int2ig_data(int2ig_data),
  .int_addr_data(int_addr_data),
  .int_read_write(int_read_write),
  .int_ready(int_ready),
  .int_valid(int_valid),
  .new_tran(new_tran),
  .int_read_done(int_read_done),
  .trans_started(trans_started),
  .current_read_write(current_read_write),
  .rd_ready(rd_ready)
);

arbiter arb (
  .clk(clk),
  .rstN(rstN),
  .int_ready(int_ready),
  .int_valid(int_valid),
  .trans_started(trans_started),
  .ig_req({valid3,valid2,valid1,valid0}),
  .ig_sel(ig_sel)
);

port_select p_sel (
  .clk(clk),
  .ig_sel(ig_sel),
  .int_read_write0(int_read_write0),
  .int_read_write1(int_read_write1),
  .int_read_write2(int_read_write2),
  .int_read_write3(int_read_write3),
  .int_read_write(int_read_write),
  .int_ready0(int_ready0),
  .int_ready1(int_ready1),
  .int_ready2(int_ready2),
  .int_ready3(int_ready3),
  .int_ready(int_ready),
  .int2ig_data0(int2ig_data0),
  .int2ig_data1(int2ig_data1),
  .int2ig_data2(int2ig_data2),
  .int2ig_data3(int2ig_data3),
  .int2ig_data(int2ig_data),
  .new_tran0(new_tran0),	
  .new_tran1(new_tran1),	
  .new_tran2(new_tran2),	
  .new_tran3(new_tran3),	
  .new_tran(new_tran),	
  .int_read_done0(int_read_done0),
  .int_read_done1(int_read_done1),
  .int_read_done2(int_read_done2),
  .int_read_done3(int_read_done3),
  .int_read_done(int_read_done),
  .int_size0(int_size0),
  .int_size1(int_size1),
  .int_size2(int_size2),
  .int_size3(int_size3),
  .int_size(int_size),
  .int_valid0(int_valid0),
  .int_valid1(int_valid1),
  .int_valid2(int_valid2),
  .int_valid3(int_valid3),
  .int_valid(int_valid),
  .trans_started0(trans_started0),
  .trans_started1(trans_started1),
  .trans_started2(trans_started2),
  .trans_started3(trans_started3),
  .trans_started(trans_started),
  .current_read_write0(current_read_write0),
  .current_read_write1(current_read_write1),
  .current_read_write2(current_read_write2),
  .current_read_write3(current_read_write3),
  .current_read_write(current_read_write),
  .int_addr_data0(int_addr_data0),
  .int_addr_data1(int_addr_data1),
  .int_addr_data2(int_addr_data2),
  .int_addr_data3(int_addr_data3),
  .int_addr_data(int_addr_data)
);

endmodule // top
