module INS_NF_NMCV (port_a, port_b);
   input port_a;
   output port_b;
   mod_a inst_a (port_a, port_b);
endmodule
module mod_a (port_a, port_b);
   input port_b;
   output port_a;
   assign port_a = ~port_b;
endmodule
