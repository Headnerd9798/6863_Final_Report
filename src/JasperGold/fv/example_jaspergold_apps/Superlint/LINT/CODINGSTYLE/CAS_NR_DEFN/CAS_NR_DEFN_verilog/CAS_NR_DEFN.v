module CAS_NR_DEFN (a, b, c, sel, out1);
   input a;
   input b;
   input c;
   input [1:0] sel;
   output out1;
   reg out1;
   always @(a or b or c or sel)
   begin
      case (sel)
         2'b00: out1 = a;
         2'b01: out1 = b;
         2'b10: out1 = c;
      endcase
   end
endmodule
