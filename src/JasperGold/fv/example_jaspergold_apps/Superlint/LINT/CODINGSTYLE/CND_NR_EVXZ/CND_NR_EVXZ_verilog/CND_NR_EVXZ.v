module CND_NR_EVXZ (in_a,out_a);
   input in_a;
   output reg out_a;
   wire w;
   assign w = 1'bz;
   always @ (w or in_a) begin
      if(w)
      out_a = 1'b1;
      else 
      out_a = in_a;
   end
endmodule

