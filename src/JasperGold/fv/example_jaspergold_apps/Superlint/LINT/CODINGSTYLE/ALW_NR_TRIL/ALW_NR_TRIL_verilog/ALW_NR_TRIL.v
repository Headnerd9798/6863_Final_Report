module ALW_NR_TRIL (en,in_a,out_a);
   input en;
   input in_a;
   output reg out_a;

   always@(in_a or en )
   begin
      if(en)
      out_a = in_a;
      else
      out_a = 1'bz;
   end
endmodule
