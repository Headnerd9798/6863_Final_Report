module FLP_NR_ASRT (clk,port_a,reset,set,port_b);
   input clk;
   input reset,set;
   input port_a;
   output port_b;
   reg port_b;
   always @ (posedge clk or negedge reset or posedge set)
   begin
      if(!reset)
      port_b <= 1'b0;
      else if(set)
      port_b <= 1'b1;
      else
      port_b <= port_a;
   end
endmodule
