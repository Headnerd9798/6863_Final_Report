module FIL_MS_DUNM_test (port_a,port_b, port_c);
   input port_a, port_b;
   output port_c;

   assign port_c = port_a & port_b;

endmodule
