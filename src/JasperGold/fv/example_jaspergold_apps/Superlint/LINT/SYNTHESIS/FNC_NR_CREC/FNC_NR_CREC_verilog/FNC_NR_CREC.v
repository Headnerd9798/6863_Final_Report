module FNC_NR_CREC (a, b, x);
   input a;
   input b;
   output x;
   function func;
      input a;
      input b;
      begin
         if ( a != b )
         func = a & b;
         else
         func = func(~a, b);
      end
   endfunction
   assign x = func(a, b);
endmodule
