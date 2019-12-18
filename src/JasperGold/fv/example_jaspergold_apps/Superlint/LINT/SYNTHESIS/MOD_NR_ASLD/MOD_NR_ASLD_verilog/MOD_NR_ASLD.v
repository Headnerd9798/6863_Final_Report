module MOD_NR_ASLD (clk, q, rst, d);
   input clk, d;
   input rst;
   output q; reg q;
   wire p;
   always_ff @(posedge clk or posedge rst)
   begin
      if (rst)
      q <= p;
      else
      q <= d;
   end
endmodule
