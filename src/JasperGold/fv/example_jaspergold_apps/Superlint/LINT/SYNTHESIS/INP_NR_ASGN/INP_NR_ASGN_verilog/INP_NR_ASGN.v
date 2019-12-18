module INP_NR_ASGN (in_a, out_a);
   input in_a;
   output reg out_a;
   assign in_a = 1'b1;
   always @(in_a) 
   out_a = in_a;
endmodule

