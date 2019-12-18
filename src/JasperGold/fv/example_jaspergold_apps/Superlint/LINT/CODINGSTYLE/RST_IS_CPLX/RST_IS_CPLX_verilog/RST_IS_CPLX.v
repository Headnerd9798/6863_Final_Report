module RST_IS_CPLX (clk,rst0,rst1,in1,out1);
   input clk;
   input rst0;
   input rst1;
   input in1;
   output reg out1;

   always @ ( posedge clk or posedge( rst0&&rst1 ) )
   begin
      if (rst0&&rst1)
      out1 <= 1'b0;
      else
      out1 <= in1;
   end

endmodule
