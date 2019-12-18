module IOP_NR_UNRD (port_a, port_b, port_c);
   inout port_a;
   input port_b;
   input port_c;

   assign port_a = port_b & port_c;

endmodule 
