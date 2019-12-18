module CMB_NR_TLIO (in_a, in_b, clk, rst, out_a, out_b);
   input in_a, in_b, clk, rst;
   output reg out_a, out_b;
   DFF ff1(in_a, clk, rst, out_a);
   assign out_b = out_a & in_b;
endmodule
module DFF(in_a, clk, rst, out_a);
   input in_a, clk, rst;
   output reg out_a;
   always@(posedge clk or negedge rst)
   if(!rst)
   out_a = 0;
   else
   out_a = in_a;
endmodule

