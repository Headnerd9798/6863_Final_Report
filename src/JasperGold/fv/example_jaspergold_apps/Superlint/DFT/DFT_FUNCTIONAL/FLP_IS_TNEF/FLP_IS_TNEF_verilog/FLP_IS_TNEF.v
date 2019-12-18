module FLP_IS_TNEF(i1,clk, o1);
   input i1;
   input clk;
   output reg o1;
   always@(negedge clk) begin
      o1 = i1;
   end
endmodule
