module MOD_NO_TMSL(outp, port_a);
   input [3:0]port_a;
   output [3:0]outp;
   specify
      (port_a => outp) = 9;
   endspecify
   assign outp = port_a;
endmodule
