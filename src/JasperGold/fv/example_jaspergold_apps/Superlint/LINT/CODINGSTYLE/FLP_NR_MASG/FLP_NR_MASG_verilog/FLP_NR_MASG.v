module FLP_NR_MASG ( port_a, clk, rst, en, port_b );
   input port_a, clk, rst, en;
   output port_b;
   reg port_b;
   always @ (posedge clk or negedge rst or posedge en)
   begin
      if( !rst || en )
      port_b <= 1'b0;
      else
      port_b <= port_a;
   end
endmodule
