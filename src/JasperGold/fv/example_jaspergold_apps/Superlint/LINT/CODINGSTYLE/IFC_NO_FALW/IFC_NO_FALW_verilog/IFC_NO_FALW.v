module IFC_NO_FALW (clk,reset,port_a,port_b);
   input clk;
   input reset;
   input port_a;
   output port_b;
   reg port_b;
   always @ ( posedge clk or negedge reset )
   begin
      port_b <= port_a;
      if ( !reset )
      port_b <= 1'b0;
   end
endmodule
