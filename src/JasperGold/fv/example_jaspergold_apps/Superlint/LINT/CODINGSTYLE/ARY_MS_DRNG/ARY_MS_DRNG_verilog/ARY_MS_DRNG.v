module ARY_MS_DRNG (port_a, port_b, port_c);
   input [3:0] port_a;
   input [0:3] port_b;
   output [3:0] port_c;
   assign port_c = port_a & port_b;
endmodule
