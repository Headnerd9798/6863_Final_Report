module LAT_IS_INFR (din,dout,clk);
   output dout;
   input din;
   input clk;
   reg dout;
   always @(clk,din) 
   begin 
      if (clk == 1)
      dout = din;
   end
endmodule
