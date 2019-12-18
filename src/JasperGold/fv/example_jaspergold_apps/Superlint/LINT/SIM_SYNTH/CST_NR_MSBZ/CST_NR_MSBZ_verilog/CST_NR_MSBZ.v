module CST_NR_MSBZ (port_a, port_b);
   output [3:0] port_a;
   output [7:0] port_b;
   assign port_a = 4'bz1;
   assign port_b = 4'b?1;
endmodule
