module LAT_NR_MXCB (in_a,in_b,in_c,out_a,out_b);
   input in_a,in_b,in_c;
   output reg out_a, out_b;
   always @(in_a or in_b or in_c)
   begin
      if (in_a == 2'b00)
      begin
         out_a = in_b & in_c;
         out_b = 1'b0;
      end
      else if(in_a == 2'b01)
      begin
         out_a = 1'b0;
         out_b = in_b | in_c;
      end
      else if (in_a == 2'b10)
      begin
         out_a = 1'b0;
      end
      else
      begin
         out_a = 1'b1;
         out_b = 1'b0;
      end
   end
endmodule
