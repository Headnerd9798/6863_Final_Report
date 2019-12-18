module MOD_IS_CMBL (S,R,clk,Q,Qbar);
   input S;
   input R;
   input clk;
   output Q;
   output Qbar;
   reg M,N;

   always @(posedge clk) begin
      M <= !(S & clk);
      N <= !(R & clk);
   end
   assign Q = !(M & Qbar);
   assign Qbar = !(N & Q);

endmodule
