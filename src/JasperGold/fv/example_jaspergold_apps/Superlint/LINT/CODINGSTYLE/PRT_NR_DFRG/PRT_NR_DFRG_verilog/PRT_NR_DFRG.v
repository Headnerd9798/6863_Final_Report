module PRT_NR_DFRG (c, out1);
   input [1:0] c;
   output [3:0] out1;
   reg [1:0] out1;
   always @(c)
   out1 = c;
endmodule
