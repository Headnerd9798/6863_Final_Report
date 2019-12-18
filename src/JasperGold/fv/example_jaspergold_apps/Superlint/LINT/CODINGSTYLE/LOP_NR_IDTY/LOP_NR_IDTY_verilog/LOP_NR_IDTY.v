module LOP_NR_IDTY (port_a,port_b);
   input [7:0] port_a;
   output reg [7:0] port_b;
   logic [31:0] idx;
   always @(port_a)
   begin
      port_b = 8'd0;
      for ( idx=7; idx>0; idx=idx-1)
      port_b[idx] = port_a[idx];
   end
endmodule
