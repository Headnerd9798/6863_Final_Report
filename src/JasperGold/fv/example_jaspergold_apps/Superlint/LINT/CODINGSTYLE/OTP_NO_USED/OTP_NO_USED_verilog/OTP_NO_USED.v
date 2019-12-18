module OTP_NO_USED (port_a, port_b, port_c, port_d);
   input port_a;
   input port_b;
   output reg port_c;
   output reg port_d;

   always @ (port_a or port_b)
   case (port_a)
      1'b1 : port_d = port_b;
      default : port_d = port_a & port_b;
   endcase
endmodule
