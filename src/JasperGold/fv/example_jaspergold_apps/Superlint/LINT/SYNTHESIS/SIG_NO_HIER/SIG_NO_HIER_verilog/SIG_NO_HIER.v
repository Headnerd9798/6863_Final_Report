module SIG_NO_HIER (port_a, port_b, clk,rst,port_c,port_d); 
   input port_a, port_b, clk,rst;
   output reg port_c;
   output port_d;

   test t1(.port_a(port_a), .port_b(port_b), .port_c(port_d)); 
   always@(posedge clk or negedge rst)
   begin
      if(~rst)
      port_c <= 1'b0;
      else   
      port_c <= t1.port_a;
   end
endmodule  

module test(port_a, port_b,port_c); 
   input port_a, port_b;
   output port_c;  
   assign port_c = port_a & port_b; 
endmodule
