module CAS_NO_DEFA (in_a, in_b, in_c, in_d, sel, out_a);
   input in_a;
   input in_b;
   input in_c;
   input in_d;
   input [259:0] sel;
   output reg out_a;

   always @(in_a or in_b or in_c or in_d or sel)
   begin
      case (sel)
         260'h000000000000000000000000000000000000000000000000000000000000000000000000000 : out_a = in_a;
         260'h00000000000000000000000000000000000000000000000000000000000000000000000000f : out_a = in_b;
         260'h0000000000000000000000000000000000000000000000000000000000000000000000000ff : out_a = in_c;
         260'h00000000000000000000000000000000000000000000000000000000000000000000000ffff : out_a = in_d;
      endcase
   end
endmodule

