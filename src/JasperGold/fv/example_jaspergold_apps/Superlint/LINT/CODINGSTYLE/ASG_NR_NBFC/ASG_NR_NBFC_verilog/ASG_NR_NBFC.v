module ASG_NR_NBFC (clk, rst, result);
   input clk;
   input rst;
   output reg [3:0] result;

   function [3:0] get_address;
      input [1:0] state_var;
      begin
         case (state_var)
            2'b00: get_address <= 4'b0000;
            default: get_address <= 4'b1111;
         endcase
      end
   endfunction

   always @(posedge clk or negedge rst)
   begin
      if(~rst)
      result = get_address(2'b00);
      else
      result = get_address(2'b11);
   end

endmodule 
