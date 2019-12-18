module SIG_IS_MDRV (a,b,clk,q);
   output reg q;
   input a,b,clk;
   always_ff @(posedge clk)
   begin
      q <= a & b;
   end
   always@*
   begin
      q <= 1'b1;
   end
endmodule
