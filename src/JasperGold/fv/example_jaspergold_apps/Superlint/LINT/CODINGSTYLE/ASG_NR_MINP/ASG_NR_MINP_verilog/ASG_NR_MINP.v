module ASG_NR_MINP (port_a, port_b,port_c,port_d);
   input port_a,port_b,port_c;
   output port_d;
   assign port_a = 1'b1;
   assign port_d = port_b & port_c;
endmodule
