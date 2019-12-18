module CLK_NO_HGHI (clk,rst,in_b,in_a,out_a);
   input clk, rst;
   input in_a, in_b;
   output reg out_a;
   wire clk_b;
   always @(posedge clk_b or negedge rst)
   begin: block
      if(!rst)
      out_a = 1'b0;
      else
      out_a = in_a;
   end
   mod_b inst_b(clk, in_b, clk_b);
endmodule

module mod_b (clk_a, in_a, clk_b);
   input clk_a, in_a;
   output clk_b;
   mod_c inst_c (clk_a, in_a, clk_b);
endmodule

module mod_c (clk_a, in_a, clk_b);
   input clk_a, in_a;
   output reg  clk_b;

   always@(posedge clk_a)
   clk_b <= in_a;
endmodule
