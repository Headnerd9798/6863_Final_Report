module MOD_NR_FORE ();
   reg clk;
   always@*
   begin clk = 1'b0;
      forever clk = ~clk;
   end
endmodule
