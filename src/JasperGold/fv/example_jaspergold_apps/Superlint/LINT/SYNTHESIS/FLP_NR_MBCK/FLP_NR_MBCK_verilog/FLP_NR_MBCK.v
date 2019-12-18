module FLP_NR_MBCK (q, d, clk);
   input d;
   input [8:0]clk;
   output q;
   reg q;
   always @( posedge clk )
   q <= d;
endmodule
