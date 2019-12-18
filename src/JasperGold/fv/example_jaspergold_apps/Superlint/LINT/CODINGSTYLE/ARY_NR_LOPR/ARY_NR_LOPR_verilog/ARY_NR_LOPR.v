module ARY_NR_LOPR (x, a, b);
   output x;
   input [1:0] a,b;
   reg y, z;
   assign x = !{y,z};
   always @(a or b)
   begin
      y = a && 2'b10;
      z = 2 || b ;
   end
endmodule
