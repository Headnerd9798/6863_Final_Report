//---------------------------------------------------------------------------//
//                                                                           //
//  Module:  port_select                                                     //
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

module port_select (
  clk,
  ig_sel,
  // Ingress side
  int_read_write0, int_read_write1, int_read_write2, int_read_write3,
  int_valid0, int_valid1, int_valid2, int_valid3,
  trans_started0, trans_started1, trans_started2, trans_started3,
  current_read_write0, current_read_write1,
  current_read_write2, current_read_write3,
  int_size0, int_size1, int_size2, int_size3,
  int_addr_data0, int_addr_data1, int_addr_data2, int_addr_data3,
  int_ready0, int_ready1, int_ready2, int_ready3,
  new_tran0, new_tran1, new_tran2, new_tran3,
  int2ig_data0, int2ig_data1, int2ig_data2, int2ig_data3,
  int_read_done0, int_read_done1, int_read_done2, int_read_done3,
  // Egress side
  int_read_write,
  int_valid,
  trans_started,
  current_read_write,
  int_size,
  int_addr_data,
  int_ready,
  new_tran,
  int2ig_data,
  int_read_done
);

input clk;

// Port selector from arbiter
input  [1:0] ig_sel;

// Ingress side
input  int_read_write0, int_read_write1, int_read_write2, int_read_write3;
input  int_valid0, int_valid1, int_valid2, int_valid3;
input  trans_started0, trans_started1, trans_started2, trans_started3;
input  current_read_write0, current_read_write1,
       current_read_write2, current_read_write3;
input  [1:0] int_size0, int_size1, int_size2, int_size3;
input [38:0]  int_addr_data0, int_addr_data1, int_addr_data2, int_addr_data3;
output int_ready0, int_ready1, int_ready2, int_ready3;
output new_tran0, new_tran1, new_tran2, new_tran3;
output [31:0] int2ig_data0, int2ig_data1, int2ig_data2, int2ig_data3;
output int_read_done0, int_read_done1, int_read_done2, int_read_done3;

// Egress side
output int_read_write;
output int_valid;
output trans_started;
output current_read_write;
output [1:0] int_size;
output [38:0] int_addr_data;
input  int_ready;
input  new_tran;
input  [31:0] int2ig_data;
input  int_read_done;


assign int_ready0 = (ig_sel==2'b00)? int_ready:1'b0;
assign int_ready1 = (ig_sel==2'b01)? int_ready:1'b0;
assign int_ready2 = (ig_sel==2'b10)? int_ready:1'b0;
assign int_ready3 = (ig_sel==2'b11)? int_ready:1'b0;

assign int2ig_data0 = int2ig_data;
assign int2ig_data1 = int2ig_data;
assign int2ig_data2 = int2ig_data;
assign int2ig_data3 = int2ig_data;

assign new_tran0 = (ig_sel==2'b00)? new_tran:1'b0;
assign new_tran1 = (ig_sel==2'b01)? new_tran:1'b0;
assign new_tran2 = (ig_sel==2'b10)? new_tran:1'b0;
assign new_tran3 = (ig_sel==2'b11)? new_tran:1'b0;

assign int_read_done0 = (ig_sel==2'b00)? int_read_done:1'b0;
assign int_read_done1 = (ig_sel==2'b01)? int_read_done:1'b0;
assign int_read_done2 = (ig_sel==2'b10)? int_read_done:1'b0;
assign int_read_done3 = (ig_sel==2'b11)? int_read_done:1'b0;

assign int_size = (ig_sel==2'b00)? int_size0:
                  (ig_sel==2'b01)? int_size1:
                  (ig_sel==2'b10)? int_size2:
                                   int_size3;

assign int_read_write = (ig_sel==2'b00)? int_read_write0:
                        (ig_sel==2'b01)? int_read_write1:
                        (ig_sel==2'b10)? int_read_write2:
                                         int_read_write3;

assign int_valid = (ig_sel==2'b00)? int_valid0:
                   (ig_sel==2'b01)? int_valid1:
                   (ig_sel==2'b10)? int_valid2:
                                    int_valid3;

assign trans_started = (ig_sel==2'b00)? trans_started0:
                       (ig_sel==2'b01)? trans_started1:
                       (ig_sel==2'b10)? trans_started2:
                                        trans_started3;

assign current_read_write = (ig_sel==2'b00)? current_read_write0:
                            (ig_sel==2'b01)? current_read_write1:
                            (ig_sel==2'b10)? current_read_write2:
                                             current_read_write3;

assign int_addr_data = (ig_sel==2'b00)? int_addr_data0:
                       (ig_sel==2'b01)? int_addr_data1:
                       (ig_sel==2'b10)? int_addr_data2:
                                        int_addr_data3;

endmodule // port_select
