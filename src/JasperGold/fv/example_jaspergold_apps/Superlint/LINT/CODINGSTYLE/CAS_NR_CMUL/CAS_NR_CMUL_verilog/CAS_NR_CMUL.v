module CAS_NR_CMUL (a,b,c,sel,out1); 
   input a, b, c; 
   input [3:0] sel; 
   output out1; 
   reg out1; 
   always @ (a or b or c or sel) 
   begin   
      case(sel)     
         0 : out1 = a;
         2 : out1 = b;     
         0 : out1 = c;            
         default : 
         out1 = 1'b0;    
      endcase 
   end 
endmodule

