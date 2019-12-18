module FNC_MS_AFPR (a, out1);
   input a;
   output integer out1;
   reg out2;

   function func1;
      input a;
      output d;
      begin
         d = a;
      end
   endfunction

   assign out2 = func1(a, out1);
endmodule

