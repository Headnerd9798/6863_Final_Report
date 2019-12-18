module MOD_NS_ADAS (en,var_b);
   input en; 
   output reg [3:0] var_b; 

   always @ (en)   
   begin     
      if (en)       
      assign var_b = 4'b0000;     
      else       
      deassign var_b;   
   end 
endmodule

