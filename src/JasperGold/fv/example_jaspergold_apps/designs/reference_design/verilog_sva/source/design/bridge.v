//---------------------------------------------------------------------------//
//                                                                           //
//  Module:  bridge                                                          //
//                                                                           //
//  Version: 15 December 2011                                                //
//---------------------------------------------------------------------------//

//*****************************************************************************
//
// Any disclosure about the Jasper Design Automation software or its use
// model to any third party violates the written Non-Disclosure Agreement
// between Jasper Design Automation and the customer.
//
// THIS SOFTWARE CONTAINS CONFIDENTIAL INFORMATION AND TRADE SECRETS OF
// JASPER DESIGN AUTOMATION, INC. USE, DISCLOSURE, OR REPRODUCTION IS
// PROHIBITED WITHOUT THE PRIOR EXPRESS WRITTEN PERMISSION OF JASPER
// DESIGN AUTOMATION, INC.
//
// Copyright (C) 2000-2017 Cadence Design Systems, Inc. All Rights
// Reserved.  Unpublished -- rights reserved under the copyright laws of
// the United States.
//
// The JasperGold Verification System incorporates software developed by
// others and redistributed according to license agreement. See
// doc/third_party_readme.txt for further details.
//
// RESTRICTED RIGHTS LEGEND
//
// Use, duplication, or disclosure by the Government is subject to
// restrictions as set forth in subparagraph (c) (1) (ii) of the Rights in
// Technical Data and Computer Software clause at DFARS 252.227-7013 or
// subparagraphs (c) (1) and (2) of Commercial Computer Software -- Restricted
// Rights at 48 CFR 52.227-19, as applicable.
//
//
//                        Jasper Design Automation, Inc.
//                        707 California St.
//                        Mountain View, CA 94041
//
// For technical assistance please send email to support@jasper-da.com.
//
// For more information on the Jasper Design Automation product offering
// send email to info@jasper-da.com.
//
//*****************************************************************************

`define ADDR_HI 40
`define ADDR_LO 34
`define DATA_HI 33
`define DATA_LO 2
`define SIZE_1 1
`define SIZE_0 0

module bridge (
  clk, rstN,
  int2eg_data, eg2int_data, int_datavalid, int_datardy, trans_started,
  int_size, int2ig_data, int_addr_data, int_read_write, current_read_write,
  int_ready, int_read_done, rd_ready, int_valid, new_tran
);

input clk;
input rstN;

// Internal bridge to eg interface
output int_datavalid;
input int_datardy;
output [7:0] int2eg_data;
input [7:0] eg2int_data;

// Ingress interface
input [1:0] int_size;
output [31:0] int2ig_data;
input [38:0] int_addr_data;
input int_read_write;
output int_ready;
input int_valid;
output new_tran;
output int_read_done;
input trans_started;
input  current_read_write;
output rd_ready;

reg [40:0] fifo[0:15];
reg [3:0] rd_ptr;
reg [3:0] wr_ptr;

wire read_dep;
wire rd_ready = ~read_dep;
wire fifo_full = wr_ptr == (rd_ptr - 4'b1);
wire fifo_empty = wr_ptr == rd_ptr;

wire int_ready = ~(read_dep && int_read_write) && ~fifo_full;

reg int_datavalid_tmp;
wire int_datavalid = int_datavalid_tmp && ~fifo_empty;

wire [40:0] fifo_out = fifo[rd_ptr];

wire [1:0] out_size = int_read_write?2'b00:fifo_out[1:0];

// The byte number of the FIFO entry to be sent to the eg block
reg [1:0] byte_num;

reg [7:0] int2eg_data;

reg [6:0] read_addr;

// The address of the transaction is being sent
reg addr_fifo;

wire last_byte_num = (out_size==2'b00 && byte_num==2'b11)
                  || (out_size==2'b01 && byte_num==2'b00)
                  || (out_size==2'b10 && byte_num==2'b01)
                  || (out_size==2'b11 && byte_num==2'b10);

wire int2eg_end = int_datavalid && last_byte_num && ~addr_fifo;
wire new_tran = fifo_empty || (int2eg_end && int_datardy);
wire int_read_done = int2eg_end && int_datardy && int_read_write;

always @(posedge clk or negedge rstN) begin
if (!rstN) addr_fifo <= 1'b1;
else if (int_datavalid && int_datardy && int_ready)
           addr_fifo <= ~addr_fifo;
end

always @(addr_fifo or read_dep or read_addr or int_read_write or fifo_out
  or byte_num)
if ( int_read_write && ~read_dep)
       case (byte_num)
        2'b00: int2eg_data = {1'b1,read_addr};
        2'b01: int2eg_data = {1'b1,read_addr+7'd1};
        2'b10: int2eg_data = {1'b1,read_addr+7'd2};
        2'b11: int2eg_data = {1'b1,read_addr+7'd3};
       endcase
else begin
        case (byte_num)
        2'b00: if (addr_fifo)
                    int2eg_data = {1'b0,fifo_out[`ADDR_HI:`ADDR_LO]};
               else int2eg_data = fifo_out[`DATA_LO+7:`DATA_LO];
        2'b01: if (addr_fifo)
                    int2eg_data = {1'b0,(fifo_out[`ADDR_HI:`ADDR_LO]+7'd1)};
               else int2eg_data = fifo_out[`DATA_LO+15:`DATA_LO+8];
        2'b10: if (addr_fifo)
                    int2eg_data = {1'b0,(fifo_out[`ADDR_HI:`ADDR_LO]+7'd2)};
               else int2eg_data = fifo_out[`DATA_HI-8:`DATA_HI-15];
        2'b11: if (addr_fifo)
                    int2eg_data = {1'b0,(fifo_out[`ADDR_HI:`ADDR_LO]+7'd3)};
               else int2eg_data = fifo_out[`DATA_HI:`DATA_HI-7];
        endcase
end

wire [6:0] new_addr_dep;

// Which FIFO entry is valid
reg [15:0] fifo_entry_valid;

// The address portion of fifo
wire [6:0] fifo_addr[0:15];

wire [40:0] fifo0 = fifo[0];
wire [40:0] fifo1 = fifo[1];
wire [40:0] fifo2 = fifo[2];
wire [40:0] fifo3 = fifo[3];
wire [40:0] fifo4 = fifo[4];
wire [40:0] fifo5 = fifo[5];
wire [40:0] fifo6 = fifo[6];
wire [40:0] fifo7 = fifo[7];
wire [40:0] fifo8 = fifo[8];
wire [40:0] fifo9 = fifo[9];
wire [40:0] fifo10 = fifo[10];
wire [40:0] fifo11 = fifo[11];
wire [40:0] fifo12 = fifo[12];
wire [40:0] fifo13 = fifo[13];
wire [40:0] fifo14 = fifo[14];
wire [40:0] fifo15 = fifo[15];

assign fifo_addr[0] = fifo0[`ADDR_HI:`ADDR_LO];
assign fifo_addr[1] = fifo1[`ADDR_HI:`ADDR_LO];
assign fifo_addr[2] = fifo2[`ADDR_HI:`ADDR_LO];
assign fifo_addr[3] = fifo3[`ADDR_HI:`ADDR_LO];
assign fifo_addr[4] = fifo4[`ADDR_HI:`ADDR_LO];
assign fifo_addr[5] = fifo5[`ADDR_HI:`ADDR_LO];
assign fifo_addr[6] = fifo6[`ADDR_HI:`ADDR_LO];
assign fifo_addr[7] = fifo7[`ADDR_HI:`ADDR_LO];
assign fifo_addr[8] = fifo8[`ADDR_HI:`ADDR_LO];
assign fifo_addr[9] = fifo9[`ADDR_HI:`ADDR_LO];
assign fifo_addr[10] = fifo10[`ADDR_HI:`ADDR_LO];
assign fifo_addr[11] = fifo11[`ADDR_HI:`ADDR_LO];
assign fifo_addr[12] = fifo12[`ADDR_HI:`ADDR_LO];
assign fifo_addr[13] = fifo13[`ADDR_HI:`ADDR_LO];
assign fifo_addr[14] = fifo14[`ADDR_HI:`ADDR_LO];
assign fifo_addr[15] = fifo15[`ADDR_HI:`ADDR_LO];

integer i;
wire [3:0] wr_ptr_minus1 = wr_ptr - 4'd1;

always @(wr_ptr or rd_ptr or wr_ptr_minus1)
begin
    if (wr_ptr==rd_ptr) fifo_entry_valid = 16'b0;
    else
      for (i=0;i<16; i=i+1) begin
        if (wr_ptr_minus1>=rd_ptr) begin
            if (wr_ptr_minus1 >= i && rd_ptr <= i)
                    fifo_entry_valid[i] = 1'b1;
            else    fifo_entry_valid[i] = 1'b0;
        end
        else begin
            if (rd_ptr <= i || wr_ptr > i)
                    fifo_entry_valid[i] = 1'b1;
            else    fifo_entry_valid[i] = 1'b0;
        end
     end
end

wire [6:0] new_addr = int_addr_data[38:32];

assign new_addr_dep[0] = fifo_entry_valid[0]
                         && ((new_addr>=fifo_addr[0])
                             || (new_addr+7'd7<=(fifo_addr[0]+7'd7))
                             || ((new_addr+7'd7>fifo_addr[0]+7'd7)
                                &&(new_addr<fifo_addr[0])));
assign new_addr_dep[1] = fifo_entry_valid[1]
                         && ((new_addr>=fifo_addr[1])
                             || (new_addr+7'd7<=(fifo_addr[1]+7'd7))
                             || ((new_addr+7'd7>fifo_addr[1]+7'd7)
                                &&(new_addr<fifo_addr[1])));
assign new_addr_dep[2] = fifo_entry_valid[2]
                         && ((new_addr>=fifo_addr[2])
                             || (new_addr+7'd7<=(fifo_addr[2]+7'd7))
                             || ((new_addr+7'd7>fifo_addr[2]+7'd7)
                                &&(new_addr<fifo_addr[2])));
assign new_addr_dep[3] = fifo_entry_valid[3]
                         && ((new_addr>=fifo_addr[3])
                             || (new_addr+7'd7<=(fifo_addr[3]+7'd7))
                             || ((new_addr+7'd7>fifo_addr[3]+7'd7)
                                &&(new_addr<fifo_addr[3])));
assign new_addr_dep[4] = fifo_entry_valid[4]
                         && ((new_addr>=fifo_addr[4])
                             || (new_addr+7'd7<=(fifo_addr[4]+7'd7))
                             || ((new_addr+7'd7>fifo_addr[4]+7'd7)
                                &&(new_addr<fifo_addr[4])));
assign new_addr_dep[5] = fifo_entry_valid[5]
                         && ((new_addr>=fifo_addr[5])
                             || (new_addr+7'd7<=(fifo_addr[5]+7'd7))
                             || ((new_addr+7'd7>fifo_addr[5]+7'd7)
                                &&(new_addr<fifo_addr[5])));
assign new_addr_dep[6] = fifo_entry_valid[6]
                         && ((new_addr>=fifo_addr[6])
                             || (new_addr+7'd7<=(fifo_addr[6]+7'd7))
                             || ((new_addr+7'd7>fifo_addr[6]+7'd7)
                                &&(new_addr<fifo_addr[6])));

always @(posedge clk or negedge rstN)
if (!rstN) begin
       read_addr <= 7'b0;
end
else if (int_datavalid && int_read_write) begin
        read_addr <=  int_addr_data[38:32];
end

assign read_dep = |new_addr_dep;

always @(posedge clk or negedge rstN)
if (!rstN)
      int_datavalid_tmp <= 1'b0;
else if ((int_read_write|~fifo_empty) && int_ready)
      int_datavalid_tmp <= 1'b1;
else if (~int_read_write&&fifo_empty)
      int_datavalid_tmp <= 1'b0;
else if (trans_started && int_read_write)
      int_datavalid_tmp <= 1'b0;

always @(posedge clk or negedge rstN)
if (!rstN) begin
       fifo[0] <= 41'd0;
       fifo[1] <= 41'd0;
       fifo[2] <= 41'd0;
       fifo[3] <= 41'd0;
       fifo[4] <= 41'd0;
       fifo[5] <= 41'd0;
       fifo[6] <= 41'd0;
       fifo[7] <= 41'd0;
       fifo[8] <= 41'd0;
       fifo[9] <= 41'd0;
       fifo[10] <= 41'd0;
       fifo[11] <= 41'd0;
       fifo[12] <= 41'd0;
       fifo[13] <= 41'd0;
       fifo[14] <= 41'd0;
       fifo[15] <= 41'd0;
end
else if (int_valid && ~int_read_write)
       fifo[wr_ptr] <= {int_addr_data, int_size};


always @(posedge clk or negedge rstN)
if (!rstN) begin
        rd_ptr <= 4'd0;
        wr_ptr <= 4'd0;
end
else begin
        if (int_valid && int_ready &&  ~current_read_write)
          wr_ptr <= wr_ptr + 4'd1;
        if (int_datavalid && int_datardy && int2eg_end
          && ~(~read_dep && int_read_write))
          rd_ptr <= rd_ptr + 4'd1;
end

always @(posedge clk or negedge rstN)
if (!rstN) begin
    byte_num <= 2'b0;
end
else begin
    if (~addr_fifo && int_datardy && out_size!=2'b01 && byte_num==2'b0)
        byte_num <= 2'b1;
    else if (~addr_fifo && int_datavalid && int_datardy) begin
        if (out_size !=2'b10 && byte_num==2'b01)
               byte_num <= 2'b10;
        else if (out_size!=2'b11 && byte_num==2'b10)
               byte_num <= 2'b11;
        else   byte_num <= 2'b00;
    end
end

endmodule // bridge
