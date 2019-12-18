module MOD_IS_EBXE (a,b,o);
   input  a,b ;
   output [2:0] o;
   mod_2 inst(.a(a),.b(b),.o(o));
endmodule

module mod_2(a,b,o);
   input a,b;
   output [2:0] o;
   assign o=a + b;
endmodule

