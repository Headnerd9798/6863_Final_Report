module INP_UC_INST (port_a, port_b);
   input port_a;
   output port_b;
   mod_b inst_a(.port_a(), .port_b(port_b), .port_c());
endmodule
module mod_b(port_a, port_b, port_c);
   input port_a, port_c;
   output port_b;
   wire wir_b;
   assign port_b = port_a;
   assign wir_b = port_c;
endmodule
