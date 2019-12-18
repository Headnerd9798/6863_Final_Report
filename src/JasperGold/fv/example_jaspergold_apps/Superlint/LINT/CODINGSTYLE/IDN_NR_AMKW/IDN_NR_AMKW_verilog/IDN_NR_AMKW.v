module IDN_NR_AMKW (port_a, port_b, abs);
   input port_a, port_b;
   output abs;
   assign abs = port_a & port_b;
endmodule
