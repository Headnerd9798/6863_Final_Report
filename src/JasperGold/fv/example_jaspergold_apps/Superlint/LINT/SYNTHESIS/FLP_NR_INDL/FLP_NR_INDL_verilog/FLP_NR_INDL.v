module FLP_NR_INDL (port_a, clk, port_b);
   input port_a, clk;
   output reg port_b = 1'b0;
   always@(posedge clk)
   port_b = port_a;
endmodule
