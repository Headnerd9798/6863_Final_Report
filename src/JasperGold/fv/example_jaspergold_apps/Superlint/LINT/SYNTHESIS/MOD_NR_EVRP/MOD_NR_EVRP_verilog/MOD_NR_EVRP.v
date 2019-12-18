module MOD_NR_EVRP (clk, num, data, q);
   input clk;
   input num;
   input data;
   output q;
   reg q;
   always @(clk or num or data)
   begin
      q = repeat(num) @(clk) data;
   end
endmodule
