module ALW_NR_MXCK (clk, q, d, rst1, rst2);
   input clk, d, rst1, rst2;
   output q;
   reg q;
   always @( clk or posedge rst1 )
   begin
      if (rst2)
      q <= d;
   end
endmodule
