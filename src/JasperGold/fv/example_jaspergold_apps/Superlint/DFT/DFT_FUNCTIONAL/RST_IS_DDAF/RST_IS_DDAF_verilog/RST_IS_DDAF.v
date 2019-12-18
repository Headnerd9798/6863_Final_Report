module RST_IS_DDAF(port_a, port_b, clk, rst, port_c);
   input port_a;
   input clk ;
   input rst;
   output port_c;
   output port_b;
   reg port_c;
   reg port_b;
   always@(posedge clk or negedge rst)
   begin
      if ( rst == 1'b0 )
      port_b <= 1'b0;
      else
      port_b <= port_a;
   end
   always@(posedge clk)
   begin
      port_c <= rst;
   end
endmodule
