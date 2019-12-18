module IOP_NR_UASG (port_a, port_b, port_c, port_e);
   inout port_a;
   input port_b;
   input port_c;
   output port_e;
   reg port_e;

   always @ (port_a or port_b)
   begin
      case (port_c)
         1'b1 : port_e = port_a;
         default : port_e = port_b;
      endcase
   end
endmodule 
