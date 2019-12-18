module ARY_NR_SLRG (in_a, in_b, out_c);
   input [3:3] in_a;
   input [3:0] in_b;
   output [4:0] out_c;
   assign out_c = {in_a, in_b};
endmodule
