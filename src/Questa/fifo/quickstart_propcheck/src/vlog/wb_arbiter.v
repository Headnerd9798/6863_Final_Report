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
//
// Wishbone Arbiter
//
// Round robin arbiter for requests with the same priority.
// Supports 5 request grant pairs. No grant is asserted when there
// is no request.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns

module wb_arbiter 
  ( clk, rst, rqst_i, gnt_o );

   input		clk;
   input		rst;
   input	[4:0]	rqst_i;		// Req input
   output	[4:0]	gnt_o;		// Grant output

   wire		clk;
   wire		rst;
   wire	[4:0]	rqst_i;
   wire	[4:0]	gnt_o;
   
   reg [5:0] cur_state;
   reg 	     clear;

   assign    gnt_o = cur_state[4:0] & {5{!clear}};
   
       
///////////////////////////////////////////////////////////////////////
//
// Next State Logic
//   - implements round robin arbitration algorithm
//   - switches grant if current req is dropped or next is asserted
//   - parks at last grant
//

   always @(posedge clk or posedge rst)
     if(rst)
       begin
	  cur_state <= 6'b10_0000;
	  clear <= 0;
       end
     else
       begin
	  if (|rqst_i) 
	    clear <= 0;
	  
	  case(cur_state)		// synopsys parallel_case full_case
 	    6'b10_0000 :
	      begin
		 if(rqst_i[0])                 cur_state <= 6'b00_0001;
		 else if(rqst_i[1])            cur_state <= 6'b00_0010;
		 else if(rqst_i[2])            cur_state <= 6'b00_0100;
		 else if(rqst_i[3])            cur_state <= 6'b00_1000;
		 else if(rqst_i[4])            cur_state <= 6'b01_0000;
		 else   
		   clear <=1;
	      end
	    
 	    6'b00_0001:
	      begin
		 if(rqst_i[0] && !clear)        cur_state <= 6'b00_0001;
		 else if(rqst_i[1])             cur_state <= 6'b00_0100;
		 else if(rqst_i[2])             cur_state <= 6'b00_0100;
		 else if(rqst_i[3])             cur_state <= 6'b00_1000;
		 else if(rqst_i[4])             cur_state <= 6'b01_0000;
		 else if(rqst_i[0])             cur_state <= 6'b00_0001;
		 else
		   clear <=1;
	      end
	    
 	    6'b00_0010:
	      begin
		 if(rqst_i[1] && !clear)        cur_state <= 6'b00_0010;
		 else if(rqst_i[2])             cur_state <= 6'b00_0100;
		 else if(rqst_i[3])             cur_state <= 6'b00_1000;
		 else if(rqst_i[4])             cur_state <= 6'b01_0000;
		 else if(rqst_i[0])             cur_state <= 6'b00_0001;
		 else if(rqst_i[1])             cur_state <= 6'b00_0010;
		 else
		   clear <=1;
	      end
	    
 	    6'b00_0100:
	      begin
		 if(rqst_i[2] && !clear)        cur_state <= 6'b00_0100;
		 else if(rqst_i[3])             cur_state <= 6'b00_1000;
		 else if(rqst_i[4])             cur_state <= 6'b01_0000;
		 else if(rqst_i[0])             cur_state <= 6'b00_0001;
		 else if(rqst_i[1])             cur_state <= 6'b00_0010;
		 else if(rqst_i[2])             cur_state <= 6'b00_0100;
		 else
		   clear <=1;
	      end
	    
 	    6'b00_1000:
	      begin
		 if(rqst_i[3] && !clear)        cur_state <= 6'b00_1000;
		 else if(rqst_i[4])             cur_state <= 6'b01_0000;
		 else if(rqst_i[0])             cur_state <= 6'b00_0001;
		 else if(rqst_i[1])             cur_state <= 6'b00_0010;
		 else if(rqst_i[2])             cur_state <= 6'b00_0100;
		 else if(rqst_i[3])             cur_state <= 6'b00_1000;
		 else
		   clear <=1;
	      end

 	    6'b01_0000:
	      begin
		 if(rqst_i[4] && !clear)        cur_state <= 6'b01_0000;
		 else if(rqst_i[0])             cur_state <= 6'b00_0001;
		 else if(rqst_i[1])             cur_state <= 6'b00_0010;
		 else if(rqst_i[2])             cur_state <= 6'b00_0100;
		 else if(rqst_i[3])             cur_state <= 6'b00_1000;
		 else if(rqst_i[4])             cur_state <= 6'b01_0000;
		 else
		   clear <=1;
	      end
            default : cur_state <= cur_state;

	  endcase
       end
endmodule
