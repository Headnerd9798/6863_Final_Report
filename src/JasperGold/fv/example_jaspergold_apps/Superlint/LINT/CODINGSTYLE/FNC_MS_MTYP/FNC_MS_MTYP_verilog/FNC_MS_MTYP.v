module FNC_MS_MTYP (a, out1);
   input a;
   output out1;
   integer out1;
   always @(a)
   t1(a, out1);
   task t1;
      input a;
      output out1;
      begin
         out1 = a;
      end
   endtask
endmodule
