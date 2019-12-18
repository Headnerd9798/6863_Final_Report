module ALW_NO_ETRG (port_d, port_q);
   input port_d;
   output port_q;
   reg port_q;
   always
   begin
      port_q = port_d;
   end
endmodule
