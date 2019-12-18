module IDN_NR_VHKW (b,a);
   input a;
   output b;
   function my_function;
      input in;
      reg unused;
      my_function = ~in;
   endfunction
   assign b = my_function(a);
endmodule
