//////////////////////////////////////////////////////////////////
//                                                              //
//  Generic Asynchronous FIFO                                   //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2010 Authors and OPENCORES.ORG                 //
//                                                              //
// This source file may be used and distributed without         //
// restriction provided that this copyright statement is not    //
// removed from the file and that any derivative work contains  //
// the original copyright notice and the associated disclaimer. //
//                                                              //
// This source file is free software; you can redistribute it   //
// and/or modify it under the terms of the GNU Lesser General   //
// Public License as published by the Free Software Foundation; //
// either version 2.1 of the License, or (at your option) any   //
// later version.                                               //
//                                                              //
// This source is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the implied   //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //
// PURPOSE.  See the GNU Lesser General Public License for more //
// details.                                                     //
//                                                              //
// You should have received a copy of the GNU Lesser General    //
// Public License along with this source; if not, download it   //
// from http://www.opencores.org/lgpl.shtml                     //
//                                                              //
//////////////////////////////////////////////////////////////////


module afifo
#(
parameter D_WIDTH = 32
)
(
input                       wr_clk,
input                       rd_clk,
input                       wr_rst_n,
input                       rd_rst_n,

input   [D_WIDTH-1:0]       i_data,
output  [D_WIDTH-1:0]       o_data,
input                       i_push,
input                       i_pop,

output                      o_full,
output                      o_empty
);

reg  [2:0] wr_pointer = 'd0, rd_pointer = 'd0;
reg  [2:0] wr_pointer_d1 = 'd0, rd_pointer_d1 = 'd0;
reg  [2:0] wr_pointer_d2 = 'd0, rd_pointer_d2 = 'd0;
wire [2:0] wr_pointer_rd, rd_pointer_wr;


reg [D_WIDTH-1:0] data [3:0];

//Write pointer and memory
//The memory won't be reseted
always @( posedge wr_clk, negedge wr_rst_n)
    if (~wr_rst_n)
        begin
        wr_pointer <= {D_WIDTH{1'b0}};
        end
    else if ( i_push && !o_full )
        begin
        wr_pointer <= wr_pointer + 1'd1;
        data[wr_pointer[1:0]] <= i_data;
        end

//Read pointer synchronizer
wire [2:0] gray8_rd_pointer;
assign gray8_rd_pointer = gray8(rd_pointer);
always @( posedge wr_clk, negedge wr_rst_n)
    if (~wr_rst_n)
        begin
        rd_pointer_d1 <= {D_WIDTH{1'b0}};
        rd_pointer_d2 <= {D_WIDTH{1'b0}};
        end
    else
        begin
        rd_pointer_d1 <= gray8_rd_pointer;
        rd_pointer_d2 <= rd_pointer_d1;
        end

//Read pointer
always @( posedge rd_clk, negedge rd_rst_n)
    if (~rd_rst_n)
        rd_pointer <= {D_WIDTH{1'b0}};
    else if ( i_pop && !o_empty )
        rd_pointer <= rd_pointer + 1'd1;

//Write pointer synchronizer
wire [2:0] gray8_wr_pointer;
assign gray8_wr_pointer = gray8(wr_pointer);

always @( posedge rd_clk,negedge rd_rst_n )
    if (~rd_rst_n)
        begin
        wr_pointer_d1 <= {D_WIDTH{1'b0}};
        wr_pointer_d2 <= {D_WIDTH{1'b0}};
        end
    else
        begin
        wr_pointer_d1 <= gray8_wr_pointer;
        wr_pointer_d2 <= wr_pointer_d1;
        end


assign wr_pointer_rd = ungray8(wr_pointer_d2);
assign rd_pointer_wr = ungray8(rd_pointer_d2);

reg [D_WIDTH-1:0] buffer_data;
always @ (posedge rd_clk, negedge rd_rst_n)
    if (~rd_rst_n)
        buffer_data <= {D_WIDTH{1'b0}};
    else
        buffer_data <= data[rd_pointer[1:0]];

assign o_data  = buffer_data;
assign o_full  = {~wr_pointer[2], wr_pointer[1:0]} == rd_pointer_wr;
assign o_empty = wr_pointer_rd == rd_pointer;


function [2:0] gray8;
input [2:0] binary;
begin
    case(binary)
        3'b000 : gray8 = 3'b000;
        3'b001 : gray8 = 3'b001;
        3'b010 : gray8 = 3'b011;
        3'b011 : gray8 = 3'b010;
        3'b100 : gray8 = 3'b110;
        3'b101 : gray8 = 3'b111;
        3'b110 : gray8 = 3'b101;
        3'b111 : gray8 = 3'b100;
    endcase
end
endfunction


function [2:0] ungray8;
input [2:0] gray;
begin
    case(gray)
        3'b000 : ungray8 = 3'b000;
        3'b001 : ungray8 = 3'b001;
        3'b011 : ungray8 = 3'b010;
        3'b010 : ungray8 = 3'b011;
        3'b110 : ungray8 = 3'b100;
        3'b111 : ungray8 = 3'b101;
        3'b101 : ungray8 = 3'b110;
        3'b100 : ungray8 = 3'b111;
    endcase
end
endfunction

endmodule

