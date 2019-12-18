module ARY_NR_LBND (in_a, in_b, out_a);
   input [1:0] in_a, in_b;
   output [4:1] out_a;
   assign out_a = {in_a, in_b};
endmodule
