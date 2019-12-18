module CAS_NR_EXCS (in_a, in_b, out_c);
   input [2:0] in_a,in_b;
   output reg [1:0] out_c;
   
   always @( in_a or in_b )
   begin
      case( in_a & in_b )
         3'b000 : out_c = 2'b00;
         3'b001 : out_c = 2'b01;
         default : out_c = 2'bxx;
      endcase
   end
endmodule

