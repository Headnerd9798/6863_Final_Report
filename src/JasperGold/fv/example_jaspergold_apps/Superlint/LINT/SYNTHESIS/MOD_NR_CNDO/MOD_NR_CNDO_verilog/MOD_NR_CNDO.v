module MOD_NR_CNDO (a, b, sel, sel2, out1, out2);
   input a;
   input b;
   input sel;
   input sel2;
   output out1;
   output reg out2;
   assign out1 = (sel === 1'bx) ? a : b;
   assign out2 = (sel2 !== 1'bz) ? a : b;
   always@*
   begin
      if(sel2 === 1'bz)
      out2 = a;
      else
      out2 = b;
   end
endmodule
