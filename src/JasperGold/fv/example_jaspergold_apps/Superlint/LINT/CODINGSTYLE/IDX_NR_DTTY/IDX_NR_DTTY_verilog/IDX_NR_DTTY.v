module IDX_NR_DTTY (port_a , port_b);
   input [10:0] port_a;
   output reg [10:0] port_b;
   integer port_index;
   assign port_index = 3;
   always @ (port_a or port_index)
   begin
      port_b[port_index] = port_a[1];
   end
endmodule
