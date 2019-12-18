module LOP_NR_MLPV (port_a); 
   input port_a; 
   integer int_a; 
   reg [7:0] reg_a; 

   always@(port_a) 
   begin   
      for(int_a = 0; int_a < 4; int_a = int_a + 1) 
      begin       
         reg_a[2] = port_a;       
         int_a = 12;     
      end 
   end 

endmodule

