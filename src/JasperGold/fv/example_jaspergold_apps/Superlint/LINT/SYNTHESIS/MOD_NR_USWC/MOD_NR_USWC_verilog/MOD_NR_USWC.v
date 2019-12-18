module MOD_NR_USWC (port_a,port_b);
   input port_a;
   output reg port_b;
   wire en;
   always @(en)
   begin
      wait (!en) port_b = port_a;
   end
endmodule
