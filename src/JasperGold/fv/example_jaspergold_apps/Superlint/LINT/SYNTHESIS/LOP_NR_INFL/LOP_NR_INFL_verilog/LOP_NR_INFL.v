module LOP_NR_INFL (clk,port_b);
   input clk;
   output reg port_b;
   reg [31:0]i;
   always@(posedge clk)
   for ( i = 2 ; i > 0 ; i++)
   begin
      port_b <= 1'b0;
   end
endmodule
