module REG_NR_RDBA (sel,out);
   input sel;
   output reg [1:0] out;
   reg [1:0] count;
   always @(sel)
   begin
      out <= count;
      count = count + 2'd1;
   end
endmodule
