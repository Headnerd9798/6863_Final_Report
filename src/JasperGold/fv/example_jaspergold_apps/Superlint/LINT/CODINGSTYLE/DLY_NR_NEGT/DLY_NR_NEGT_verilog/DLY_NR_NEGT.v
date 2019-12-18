module DLY_NR_NEGT (in_a, in_b, sel, out_a);
   input in_a, in_b, sel;
   output reg out_a;

   always @(in_a or in_b or sel)
   begin
      if (sel)
      out_a = #10 in_a;
      else
      out_a = #(-10) in_b;
   end
endmodule

