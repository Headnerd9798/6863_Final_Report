module CLK_NS_EDMX (clk, port_a, port_b, port_c); 
   input clk, port_a; 
   output port_b, port_c; 
   reg port_b, port_c; 

   always @(posedge clk)   
   begin     
      port_b <= port_a;   
   end

   always @(negedge clk)   
   begin     
      port_c <= !port_a;   
   end 
endmodule

