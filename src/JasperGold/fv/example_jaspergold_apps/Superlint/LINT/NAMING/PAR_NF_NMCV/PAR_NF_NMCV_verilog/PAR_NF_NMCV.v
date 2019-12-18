module PAR_NF_NMCV (port_a, clk, port_b);
   input port_a, clk;
   output port_b;
   parameter par_a = 6;
   reg [1:par_a] reg_a ;
   integer P;
   always @(negedge clk)
   begin
      for (P = 1; P < par_a; P = P+1)
      reg_a[P+1] = reg_a[P];
      reg_a[1] = port_a;
   end
   assign port_b = reg_a[par_a];
endmodule
