module CLK_NO_INPT (clk, port_a, reset, port_b);  
   input clk;  
   input reset;  
   input port_a;  
   output port_b;  
   reg port_b;  
   wire clk_var;   
   assign clk_var = clk;

   always @ (posedge clk_var or negedge reset)   
   begin
      if(!reset)    
      port_b <= 1'b0;   
      else    
      port_b <= port_a; 
   end

endmodule

