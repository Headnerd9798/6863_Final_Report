module ALW_IC_SENL (a, b, c, out1);
   input a;
   input b;
   input [1:0] c;
   output out1;
   reg out1;
   always @(a or b)
   case (c)
      2'b00: out1 = a | b;
      2'b01: out1 = a & b;
      default: out1 = ~(a & b);
   endcase
endmodule
