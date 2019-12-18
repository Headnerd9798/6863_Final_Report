module REG_NR_MNBA (port_a, port_b, port_c);
   input port_a, port_b;
   output port_c;
   reg port_c;
   always @(port_a or port_b)
   begin
      port_c <= port_a;
      #10;
      port_c <= port_b;
   end
endmodule
