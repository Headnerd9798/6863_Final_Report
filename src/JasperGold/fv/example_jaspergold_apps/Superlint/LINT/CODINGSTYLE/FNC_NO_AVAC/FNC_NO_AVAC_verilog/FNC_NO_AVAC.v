module FNC_NO_AVAC (port_a,port_b,port_c);
   input port_a, port_b;
   output port_c;
   wire port_c;
   assign port_c = func_a (port_a,port_b);
   function func_a;
      input port_a,port_b;
      if (port_b)
      func_a = port_a;
   endfunction
endmodule
