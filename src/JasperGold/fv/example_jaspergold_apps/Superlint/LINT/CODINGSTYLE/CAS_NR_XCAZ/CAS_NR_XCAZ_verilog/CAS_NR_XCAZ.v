module CAS_NR_XCAZ (sel, out1);
   output [3:0] out1;
   input sel;
   reg [3:0] out1;
   always @(sel)
   casez(sel)
   2'bxx: out1 = 4'b00xx;
   2'bzz: out1 = 4'b0000;
   default: out1 = 4'b1111;
endcase
endmodule
