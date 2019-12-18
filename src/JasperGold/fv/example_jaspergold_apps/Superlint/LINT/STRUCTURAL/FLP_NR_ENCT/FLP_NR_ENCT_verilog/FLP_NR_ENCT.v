module FLP_NR_ENCT (clk,rst,port_f,port_e,var_a);
   input clk,rst,port_f,port_e;
   output var_a;
   wire en;
   reg var_a;
   assign en = 1'b0;
   always@(posedge clk or negedge rst)
   begin
      if (!rst)
      var_a <= 1'b0;
      else if(en)
      var_a <= port_f;
      else
      var_a <= port_e;
   end
endmodule
