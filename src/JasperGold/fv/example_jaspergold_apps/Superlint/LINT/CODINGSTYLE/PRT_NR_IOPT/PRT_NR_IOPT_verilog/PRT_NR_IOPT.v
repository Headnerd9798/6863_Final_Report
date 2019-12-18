module PRT_NR_IOPT (port_a, port_b, port_c);
   input port_a, port_b;
   inout port_c;
   assign port_c = port_a & port_b;
endmodule

