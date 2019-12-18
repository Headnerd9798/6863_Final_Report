module CND_NR_CMXZ (in_a, in_b, sel_a, sel_b, out_a, out_b, out_c, out_d);
   input in_a;
   input in_b;
   input sel_a;
   input sel_b;
   output out_a;
   output out_b;
   output out_c;
   output out_d;
   assign out_a = (sel_a == 1'bx) ? in_a : in_b;
   assign out_b = (sel_b == 1'bz) ? in_a : in_b;
   assign out_c = (1'bx) ? in_a : in_b;
   assign out_d = (1'bz) ? in_a : in_b;
endmodule

