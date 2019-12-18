module FLP_NO_SRST (port_a, clk, port_b);
   input port_a, clk;
   output reg port_b;
   always@(posedge clk)
   begin: block_A
      port_b <= port_a;
   end
endmodule
