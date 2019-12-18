module FLP_NR_FNIN (a, b, c, clk, rst, o);
   input a, b, clk, rst;
   input [127:0] c;
   output o;
   wire w1, w2;
   assign w1 = |c;
   assign w2 = a & b & w1;

   reg f;
   always@(posedge clk) begin
      if(rst) begin
         f <= 0;
      end
      else begin
         f <= w2;
      end
   end

   assign o = f;

endmodule

