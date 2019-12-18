module MOD_NR_FKJN (clk, cout);
   input clk;
   output cout;
   reg cout;
   always @(posedge clk)
   begin
      fork 
         cout <= 1'b0;
         cout <= 1'b1;
      join
   end
endmodule
