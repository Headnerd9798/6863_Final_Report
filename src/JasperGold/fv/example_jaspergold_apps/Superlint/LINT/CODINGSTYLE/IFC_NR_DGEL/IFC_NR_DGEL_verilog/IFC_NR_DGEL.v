module IFC_NR_DGEL (a, b, sel, sel2, outp);
   input a, b, sel, sel2;
   output outp;
   reg outp;
   always @(a or b or sel or sel2)
   begin
      if (sel)
      if (sel2)
      outp = a;
      else
      outp = b;
   end
endmodule
