module CAS_NO_CNST (a, b, c, sel, out1);
   input a;
   input b;
   input [3:0] c;
   input [3:0] sel;
   output out1;
   reg out1;
   always @(a or b or c or sel)
   begin case (sel)
         4'b0010: out1 = a;
         c: out1 = b;
         4'b011?: out1 = c;
         4'b0x11: out1 = b;
         default: out1 = 1'b1;
      endcase
   end
endmodule
