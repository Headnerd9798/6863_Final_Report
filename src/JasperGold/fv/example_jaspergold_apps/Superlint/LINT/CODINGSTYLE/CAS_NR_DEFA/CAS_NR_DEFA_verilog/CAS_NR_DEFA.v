module CAS_NR_DEFA (in_a,in_b,in_c,in_d,sel,out_a);
   input [3:0] in_a,in_b,in_c,in_d;
   input [1:0] sel;
   output reg [3:0] out_a;

   always @(in_a or in_b or in_c or in_d or sel)
   begin
      case(sel)
      2'b00: out_a = in_a;
      2'b01: out_a = in_b;
      2'b10: out_a = in_c;
      2'b11: out_a = in_d;
      default: out_a = 4'bx;
   endcase
end
endmodule

