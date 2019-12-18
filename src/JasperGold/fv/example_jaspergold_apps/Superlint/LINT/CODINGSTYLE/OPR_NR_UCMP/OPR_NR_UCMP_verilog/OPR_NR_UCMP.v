module OPR_NR_UCMP (a, b, c, d, out2);
   input [3:0] a;
   input [1:0] b;
   input [1:0] c;
   input [4:0] d;
   output out2;
   reg out1;
   reg out2;
   always @(a or b or c or d)
   begin if (a == b) out2 = 1'b1;
      if (b == c) out2 = 1'b1;
      if (c != d) out2 = 1'b1;
   end
endmodule
