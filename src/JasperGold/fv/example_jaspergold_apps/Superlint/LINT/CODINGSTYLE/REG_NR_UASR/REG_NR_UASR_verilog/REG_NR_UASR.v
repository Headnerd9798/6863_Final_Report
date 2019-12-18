module REG_NR_UASR (in1, out1);
   input in1;
   output out1;
   reg out1;
   reg g1;
   always @(in1 or g1)
   out1 <= in1 & g1;
endmodule
