module ALW_NR_MSLV (b, c, out1);
   input b;
   input c;
   output out1;
   reg out1;
   reg a;
   always @(a or b or c)
   begin
      out1 = a | b;
      a = c;
   end
endmodule
