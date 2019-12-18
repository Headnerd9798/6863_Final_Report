module ALW_NO_COMB(in1,en,out1); 
   input in1;
   input en;
   output reg out1;
   always_comb
   begin
      if(en)
      out1 = in1;
   end
endmodule
