module MOD_NF_NMCV (clk,data);
   input clk;
   input data;
   reg reg_a;
   always@(posedge clk)
   reg_a = data;
endmodule 
