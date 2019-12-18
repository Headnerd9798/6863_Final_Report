module CND_IR_CCAS (in_a, out_b, out_c, out_d);
   input [2:0] in_a;
   output reg [1:0] out_b, out_c;
   output out_d;
   parameter param_a = 2;
   parameter param_b = 3;
   assign out_d = param_b ? 0 : 1;
   always @( in_a )
   begin
      case( 1'b1 )
         in_a[0] : out_b = 2'b00;
         in_a[1] : out_b = 2'b01;
         in_a[2] : out_b = 2'b10;
         default : out_b = 2'bxx;
      endcase
      if(in_a && (param_a == 0))
      out_c = 2'b00;
   end
endmodule

