module ASG_MS_RTRU ( port_b, port_c);
   input [6:0] port_b;
   output [5:0] port_c;
   reg [5:0] port_c;
   always @(port_b)
   begin
      port_c = port_b;
   end
endmodule
