module CAS_NR_OVCI (sel,port_a); 
   input [1:0] sel ; 
   output [1:0] port_a; 
   reg [1:0] port_a; 
   always@(sel)   
   begin   
      casex (sel)     
      2'b0x : port_a = 2'b11;
      2'bx0 : port_a = 2'b01;     
      2'b11 : port_a = 2'b01;    
      default : port_a = 2'bxx;   
   endcase
end endmodule

