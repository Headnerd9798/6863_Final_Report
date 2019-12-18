module RST_IS_DLAT (port_a,en,rst_a,clk, port_c);
   input port_a;
   input clk;
   input en;
   input rst_a;
   output port_c;
   reg port_c;
   reg rst;
   always@*
   if(en)
   rst <= ~rst_a;
   always@(posedge clk or negedge rst) 
   begin
      if (!rst)
      port_c <= 1'b0;
      else
      port_c <= port_a;
   end
endmodule
