module OTP_UC_INST (port_a, port_b);
   input port_a;
   output port_b;
   mod_b inst_a(.port_a(port_a), .port_b(port_b), .port_c());
endmodule
module mod_b (port_a, port_b, port_c);
   input port_a;
   output port_b, port_c;
   wire wir_b;
   assign port_c = port_a;
   assign port_b = port_a & wir_b;
endmodule
