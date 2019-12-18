module ALW_NR_UNUV (in1, in2, out1, out2);
   input in1;
   input in2;
   output out1;
   output out2;
   reg out2;
   always @(in1 or in2)
   begin
      out2 = 1'b0;
   end
   assign out1 = in1 & in2;
endmodule
