module ALW_NR_MCLK (q, d, clk1, clk2);
   input d;
   input clk1, clk2;
   output q;
   reg q;
   always @( posedge clk1 or posedge clk2 )
   begin
      q <= d;
   end
endmodule
