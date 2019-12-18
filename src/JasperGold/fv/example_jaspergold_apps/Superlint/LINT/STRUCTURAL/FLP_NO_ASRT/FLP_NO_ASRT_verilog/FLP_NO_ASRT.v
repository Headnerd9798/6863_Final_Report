module FLP_NO_ASRT (clk, rst, in_a, out_a);
   input clk, rst;
   input in_a;
   output reg out_a;

   always@(posedge clk)
   begin
      if(!rst)
      out_a <= 1'b0;
      else
      out_a <= in_a;
   end
endmodule

