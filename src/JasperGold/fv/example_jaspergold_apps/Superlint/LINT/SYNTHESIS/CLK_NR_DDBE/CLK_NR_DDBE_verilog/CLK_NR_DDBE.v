module CLK_NR_DDBE (clk, out_a , in_a);
   input clk, in_a;
   output reg out_a;

   always @(posedge clk)
   begin
      if (clk)
      out_a <= in_a;
      else
      out_a <= ~in_a ;
   end
endmodule
