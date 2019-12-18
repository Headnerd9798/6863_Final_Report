module INP_NO_USED (in1, out1);
   input in1;
   output [6:0] out1;
   parameter [3:0] p1 = 4'b0110;
   parameter [3:0] p2 = 4'b1010;
   assign out1 = {3'b010, p2[3], p1[2:0]};
endmodule
