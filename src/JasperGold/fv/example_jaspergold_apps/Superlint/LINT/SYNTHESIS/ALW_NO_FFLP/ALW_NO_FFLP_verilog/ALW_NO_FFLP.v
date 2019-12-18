module ALW_NO_FFLP (in1,out1,en);
   input [3:0] in1;
   output reg [3:0] out1;
   input en;

   always_ff@(en or in1)   
   begin     
      if(en)       
      out1 <= in1;   
   end 
endmodule

