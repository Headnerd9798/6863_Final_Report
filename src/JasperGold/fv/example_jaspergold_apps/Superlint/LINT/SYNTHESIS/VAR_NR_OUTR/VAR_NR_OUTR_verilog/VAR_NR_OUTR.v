module VAR_NR_OUTR (b, out1); 
   input b; 
   output reg out1;
   wire [2:0] q; 
   always @(b or q)   
   out1 = q[4] & b; 
endmodule

