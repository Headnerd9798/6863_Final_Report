module CAS_NR_UCIT (a, b, c, sel, out1);
   input a;
   input b;
   input c;
   input [3:0] sel;
   output out1;
   reg out1;
   always @(a or b or c or sel)
   begin
      case (sel)
         4'b0010: out1 = a;
         2'b11: out1 = b;
         8: out1 = c;
         default: out1 = 1'b0;
      endcase
   end
endmodule
