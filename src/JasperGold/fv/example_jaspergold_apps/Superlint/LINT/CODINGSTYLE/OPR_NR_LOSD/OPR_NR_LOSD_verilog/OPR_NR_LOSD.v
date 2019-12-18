module OPR_NR_LOSD(port_a,port_b);
   output [2:0] port_a;
   output [2:0] port_b; 
   assign port_a = 4'b1111 + 4'b0111;
   assign port_b = 3'b111 * 3'b011;
endmodule
