//---------------------------------------------------------------------------//
//                                                                           //
//  Module:  egress                                                          //
//                                                                           //
//  Version: 13 July 2006                                                    //
//---------------------------------------------------------------------------//

//************************************************************************
//
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
// ***********************************************************************

`define EG_IDLE 2'b00
`define EG_ADDR 2'b01
`define EG_DATA 2'b10

module egress (
  clk, rstN,
  int2eg_data, eg2int_data, int_datavalid, int_datardy,
  eg_datain, eg_ad_dataout, eg_valid, eg_ready
);

input clk, rstN;

// Addr and data from the internal bridge
// For addr, 6:0 is the address and bit 7 is read_write information
input int_datavalid;
input [7:0] int2eg_data;
output int_datardy;
output [7:0] eg2int_data;

input eg_ready;
input [7:0] eg_datain;
output eg_valid;
output [7:0] eg_ad_dataout;

reg [1:0] nxt_state, cur_state;
reg [7:0] eg_ad_dataout;
reg [7:0] eg2int_data;
wire eg_valid = cur_state!=`EG_IDLE;

reg read_write;

always @(posedge clk or negedge rstN)
if (!rstN) read_write <= 1'b0;
else if (nxt_state==`EG_ADDR) read_write <= int2eg_data[7];

always @(posedge clk)
  if (eg_ready) eg_ad_dataout <= int2eg_data;

reg [7:0] i2c2int_data;

always @(posedge clk or negedge rstN)
if (!rstN) eg2int_data <= 8'b0;
else if (read_write && cur_state==`EG_DATA) begin
      eg2int_data <= eg_datain;
end


always @(posedge clk or negedge rstN)
if (!rstN) begin
        cur_state <= `EG_IDLE;
end
else    cur_state <= nxt_state;

always @(cur_state or int_datavalid or eg_ready) begin
case (cur_state)
`EG_IDLE: if (int_datavalid && eg_ready) nxt_state = `EG_ADDR;
       else nxt_state = `EG_IDLE;
`EG_ADDR: if (eg_ready) nxt_state = `EG_DATA;
     else nxt_state = `EG_ADDR;
`EG_DATA: if (eg_ready) begin
              if (int_datavalid) nxt_state = `EG_ADDR;
              else nxt_state = `EG_IDLE;
          end
          else nxt_state = `EG_DATA;
default: nxt_state = `EG_IDLE;
endcase

end

wire int_datardy = eg_ready;

endmodule // egress
