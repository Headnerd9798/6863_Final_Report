module IOP_NO_USED (port_a, port_b, port_c, port_d);
   inout port_a;
   input port_b;
   input port_c;
   output reg port_d;

   always @ (port_b)
   case (port_c)
      1'b1 : port_d = port_b;
      default : port_d = port_c;
   endcase
endmodule
