module ALW_NR_OPSL(clk, port_a, port_b); 
   input clk; 
   input port_a; 
   output port_b; 
   reg port_b; 
   always @(clk || port_a)   
   begin     
      port_b <= port_a;   
   end
endmodule

