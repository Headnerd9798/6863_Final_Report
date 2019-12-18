module ELB_IS_ERRO (clk, rstN, out_a, out_b, sel);
   input clk, rstN, sel;
   output reg [2:0] out_a, out_b;
   reg [2:0] next_state;
   logic log;
   always_comb 
   deassign log;

   always@(posedge clk, negedge rstN)
   begin
      if(~rstN) 
      out_a <= 0;
      else 
      out_a <= next_state;
   end
endmodule

