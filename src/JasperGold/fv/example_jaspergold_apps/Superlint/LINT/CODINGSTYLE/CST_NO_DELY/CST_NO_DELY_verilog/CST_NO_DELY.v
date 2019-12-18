module CST_NO_DELY (data, out1);
   output out1;
   input data;
   reg out1;
   integer d1;
   always @(data)
   out1 = #d1 data;
endmodule
