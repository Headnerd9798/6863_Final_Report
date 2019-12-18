module WIR_NR_UASR (clk);
   input clk;
   wire wir_a;
   reg reg_a;
   always@(posedge clk)
   reg_a = wir_a;
endmodule
