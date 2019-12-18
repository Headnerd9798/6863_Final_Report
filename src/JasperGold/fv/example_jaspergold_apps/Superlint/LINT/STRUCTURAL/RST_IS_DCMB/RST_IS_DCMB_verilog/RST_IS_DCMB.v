module RST_IS_DCMB (q, data, clk, rst_a, rst_b);
   output q;
   input data, clk, rst_a, rst_b;
   reg q;
   wire reset;
   assign reset = rst_a & rst_b;
   always @(posedge clk or negedge reset)
   begin
      if (!reset)
      q <= 1'b0;
      else
      q <= data;
   end
endmodule
