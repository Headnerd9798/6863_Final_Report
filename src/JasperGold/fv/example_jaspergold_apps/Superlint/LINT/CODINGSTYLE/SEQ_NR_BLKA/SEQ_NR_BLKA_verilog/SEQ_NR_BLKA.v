module SEQ_NR_BLKA (clk, q, d); 
   input clk, d; 
   output reg q; 
   always @(posedge clk)   
   q = d; 
endmodule

