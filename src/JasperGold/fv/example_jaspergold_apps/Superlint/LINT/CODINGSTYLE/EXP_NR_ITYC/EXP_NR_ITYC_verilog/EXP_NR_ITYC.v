module EXP_NR_ITYC (out_a, in_a);
   output reg signed [31:0] out_a;
   input integer in_a;
   always@(in_a)
   begin
      out_a = in_a;
   end
endmodule

