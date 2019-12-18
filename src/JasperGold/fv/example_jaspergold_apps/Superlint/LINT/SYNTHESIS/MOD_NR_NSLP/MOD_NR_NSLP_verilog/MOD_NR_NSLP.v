module MOD_NR_NSLP (a, b, c);
   input a, b;
   output reg c;
   reg [8:0] N;
   int i;

   always@(a or b)
   begin
      for (i = 0; i < N; i = i + 1)
      c = a & b;
   end
endmodule
