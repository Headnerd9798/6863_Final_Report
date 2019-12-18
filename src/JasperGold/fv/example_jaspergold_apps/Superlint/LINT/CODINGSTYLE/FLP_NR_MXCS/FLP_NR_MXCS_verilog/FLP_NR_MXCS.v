module FLP_NR_MXCS (in1,in2,clk,rst,out);
   input in1, in2, clk, rst;
   output reg out;

   always@(posedge clk or negedge rst)
   begin
      if(!rst)
      out <= 0;
      else
      out <= in1 && in2;
   end
endmodule
