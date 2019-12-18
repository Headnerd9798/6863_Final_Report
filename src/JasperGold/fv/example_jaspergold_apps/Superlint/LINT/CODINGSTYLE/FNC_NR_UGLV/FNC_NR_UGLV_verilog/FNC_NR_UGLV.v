module FNC_NR_UGLV(port_a,port_b,port_c);
   input port_a,port_b;
   output port_c;
   reg port_c,reg_a,reg_b;
   function func_a;
      input port_a,port_b;
      reg reg_c;
      begin
         case (reg_a)
            1'b0: reg_c = 1'b0;
            1'b1: reg_c = 1'b1;
         endcase
      end
   endfunction
   always @(port_a or port_b)
   port_c = func_a(port_a,port_b);
endmodule
