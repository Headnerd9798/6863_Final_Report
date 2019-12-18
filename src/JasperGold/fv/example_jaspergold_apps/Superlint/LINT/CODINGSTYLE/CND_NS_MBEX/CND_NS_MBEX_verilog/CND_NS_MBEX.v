module CND_NS_MBEX (outp,in_a,in_c);
   output reg [2:0] outp;
   input [2:0] in_a;
   input [2:0] in_c;
   reg [4:0] reg_b;
   always @(in_a or in_c or reg_b)
   begin
      if ( reg_b ) outp = in_a;
      else
      outp = in_c;
   end
endmodule
