module CLK_NR_EDGE (clk, in_a, out_a);
   input clk, in_a;
   output reg out_a;

   always @(posedge clk)
   if (~clk)
   out_a = in_a;
endmodule

