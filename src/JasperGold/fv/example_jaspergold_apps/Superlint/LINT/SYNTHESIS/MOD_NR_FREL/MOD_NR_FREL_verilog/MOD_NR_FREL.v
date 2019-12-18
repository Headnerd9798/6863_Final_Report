module MOD_NR_FREL (clk, cin, cout);
   input clk;
   input cin;
   output cout;
   reg cout;
   always @ (posedge clk)
   begin
      force cout = 1'b1;
      cout <= cin;
      release cout;
   end
endmodule
