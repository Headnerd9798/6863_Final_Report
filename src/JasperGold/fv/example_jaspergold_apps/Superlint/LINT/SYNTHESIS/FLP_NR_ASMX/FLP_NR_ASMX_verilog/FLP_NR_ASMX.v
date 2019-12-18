module FLP_NR_ASMX (clk, rst, port_a, port_b, port_c, port_d);
   input clk;
   input rst;
   input port_a;
   input port_b;
   output port_c,port_d;
   reg port_c;
   reg port_d;
   always @(posedge clk or negedge rst)
   if (rst==1'b0)
   port_c <= 1'b0;
   else
   begin
      port_c <= port_a;
      port_d <= port_b;
   end
endmodule
