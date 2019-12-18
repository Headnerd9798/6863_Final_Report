module SIG_IS_INTB (port_a, port_b, outp);   
   input [1:0] port_a;   
   input port_b;   
   output [1:0] outp;
   assign outp = port_b ? port_a : 2'bzz; 
endmodule

