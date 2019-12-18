module EXP_NR_OVFB (in_a, in_b, out_a, out_b);
   input [3:0] in_a;
   input [3:0] in_b;
   output reg [7:0] out_a;
   output reg [7:0] out_b;

   always @(in_a or in_b)
   begin 
      out_a = in_a << 9;
      out_b = in_b >> 3;
   end
endmodule

