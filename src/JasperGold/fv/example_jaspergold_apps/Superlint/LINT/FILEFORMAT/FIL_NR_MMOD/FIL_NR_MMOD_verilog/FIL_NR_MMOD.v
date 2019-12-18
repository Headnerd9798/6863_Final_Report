module FIL_NR_MMOD (a, b, c);
   output c;
   input a,b;
   reg c;
   bot I (.a(a),.b(b),.c(c));
endmodule

module bot (a,b,c);
   input a,b;
   output reg c;
   always @ (a or b)
   begin
      c = a & b;
   end
endmodule
