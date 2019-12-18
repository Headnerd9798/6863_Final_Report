module IDX_NR_LBOU (port_a,port_b,port_c);
   output reg [2:0] port_c;
   input [2:0] port_b;
   input [2:0] port_a;
   always@(port_b,port_a)
   port_c[port_a] = port_b[0];
endmodule
