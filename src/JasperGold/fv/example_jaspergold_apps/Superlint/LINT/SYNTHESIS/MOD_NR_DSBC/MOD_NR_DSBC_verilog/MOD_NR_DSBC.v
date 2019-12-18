module MOD_NR_DSBC (b,a);
   input a;
   output reg b;
   always@(a)
   begin : disable_check
      b = a;
      disable disable_check;
   end
endmodule
