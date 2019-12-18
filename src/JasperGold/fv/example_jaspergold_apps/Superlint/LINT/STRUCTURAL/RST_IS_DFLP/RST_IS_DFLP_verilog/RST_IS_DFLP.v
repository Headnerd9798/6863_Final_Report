module RST_IS_DFLP (port_a,rst_a,clk, port_c);
   input port_a; 
   input clk; 
   input rst_a; 
   output port_c; 
   reg port_c; 
   reg rst; 
   always@(posedge clk) 
   rst <= ~rst_a; 
   always@(posedge clk or negedge rst) 
   begin 
      if (!rst)
      port_c <= 1'b0; 
      else 
      port_c <= port_a; 
   end 
endmodule 
