module ASG_MS_RPAD(port_a, port_c);
   input [3:0] port_a;
   output [5:0] port_c;
   reg [5:0] port_c;
   always @(port_a)
   begin
      port_c = port_a;
   end
endmodule
