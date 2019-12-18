module IDX_NR_ORNG (count, d, q1); 
   output q1; 
   input [3:0] d; 
   input [2:0] count;   

   assign q1 = d[count]; 
endmodule

