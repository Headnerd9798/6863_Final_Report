module DLY_NR_ASGN (clk, rst, port_a, port_b);
   input clk;
   input rst;
   input port_a;
   output port_b;
   reg port_b;
   always @ (posedge clk or negedge rst)
   if (!rst)
   port_b <= #1 1'b0;
   else
   port_b<= #1 port_a;
endmodule
