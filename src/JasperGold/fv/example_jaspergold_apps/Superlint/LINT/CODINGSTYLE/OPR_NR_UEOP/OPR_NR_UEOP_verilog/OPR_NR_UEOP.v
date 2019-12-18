module OPR_NR_UEOP (port_a,port_b,port_c,port_d);
   input [3:0] port_a;
   input [1:0] port_b;
   output [3:0] port_c;
   output [3:0] port_d;
   reg [3:0] port_c;
   reg [3:0] port_d;
   always @(port_a or port_b)
   begin
      port_c = port_a & port_b;
      port_d = port_a | port_b;
   end
endmodule
