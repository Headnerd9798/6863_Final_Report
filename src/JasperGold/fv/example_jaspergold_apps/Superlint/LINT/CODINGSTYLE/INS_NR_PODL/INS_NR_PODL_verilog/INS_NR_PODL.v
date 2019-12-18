module INS_NR_PODL (clk, rst, ip, op);
   input clk, rst, ip;
   output reg op;
   FF inst(clk, rst, ip , op);
endmodule
module FF(clk, rst, d, out);
   input clk, rst, d;
   output reg out;
   always@(posedge clk or negedge rst)
   begin if(!rst)
      out <= 1'b0;
      else
      out <= d;
   end
endmodule
