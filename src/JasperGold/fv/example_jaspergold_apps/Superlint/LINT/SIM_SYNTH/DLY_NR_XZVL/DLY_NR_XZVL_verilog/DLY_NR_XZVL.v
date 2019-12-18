module DLY_NR_XZVL (clk, sel_a, sel_b);
   input clk;
   output reg [3:0] sel_a;
   output reg [3:0] sel_b;
   parameter delay_x = 2'bx1;
   parameter delay_z = 2'bz1;

   always @(posedge clk)
   begin
      #delay_x sel_a<= 4'b0000;
      #delay_z sel_b<= 4'b0010;
   end
endmodule

