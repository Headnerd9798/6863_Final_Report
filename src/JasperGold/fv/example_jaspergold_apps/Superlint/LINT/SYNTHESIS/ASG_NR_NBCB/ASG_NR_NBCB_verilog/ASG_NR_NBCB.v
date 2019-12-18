module ASG_NR_NBCB (in1, in2, out1);
   input in1;
   input in2;
   output out1;
   reg out1;
   always @(in1 or in2)
   out1 <= in1 & in2;
endmodule
