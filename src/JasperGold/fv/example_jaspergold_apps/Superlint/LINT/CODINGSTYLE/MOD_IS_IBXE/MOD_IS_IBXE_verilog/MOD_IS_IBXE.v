module MOD_IS_IBXE (a,b,o);
   input  a,b ;
   output [2:0] o;
   mod_2 inst(.a(a),.b(b),.o(o));
endmodule
