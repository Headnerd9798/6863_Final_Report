module FNC_NR_AVGV (port_a);
   output reg port_a;
   function func_a;
      input port_b;
      input port_c;
      if(port_b == 0)
      func_a = 1'b0;
      else
      port_a = port_c;
   endfunction
endmodule
