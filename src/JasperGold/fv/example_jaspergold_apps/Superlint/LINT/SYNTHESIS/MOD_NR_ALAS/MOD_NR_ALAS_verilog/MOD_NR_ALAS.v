module alias_module (port_a, port_a, port_b);
   input port_a;
   output port_b;
   assign port_b = port_a;
endmodule

module MOD_NR_ALAS (port_a, port_b, port_c);
   input port_a, port_b;
   output port_c;
   alias_module inst_a(port_a, port_b, port_c);
endmodule
