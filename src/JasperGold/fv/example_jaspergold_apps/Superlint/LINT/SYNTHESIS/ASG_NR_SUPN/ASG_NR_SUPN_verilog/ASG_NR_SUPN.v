module ASG_NR_SUPN (in_a, in_b, out_a);
   input in_a;
   input in_b;
   output reg [3:0] out_a;
   supply0 s0;
   supply1 s1;
   supply0 p0;
   supply1 p1;
   assign s0 = in_a;
   assign s1 = in_b;
   buf (p0, in_a);
   buf (p1, in_b);
   always @(s0 or s1 or p0 or p1)
   out_a = {s0,s1,p0,p1};
endmodule
