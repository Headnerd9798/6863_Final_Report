module CLK_XC_LDTH (in_a, in_b,rst,clk, out_a, out_b);
   input in_a, in_b,clk,rst;
   output out_a, out_b;
   reg out_a;
   assign out_b = clk & in_b;
   always @(posedge clk or negedge rst)
   if(!rst)
   out_a <= 1'b0;
   else
   out_a <= in_a;
endmodule

