`timescale 1ns/1ns
module FIL_NR_MTMS1 (out_a, in_a, in_b);
   input in_a;
   input in_b;
   output out_a;
   wire w;
   FIL_NR_MTMS2 n1(w, in_a);
   assign out_a = w & in_b;
endmodule

`timescale 1ps/1ps
module FIL_NR_MTMS2 (out_a, in_a);
   input in_a;
   output out_a;
   assign out_a = ~in_a;
endmodule

