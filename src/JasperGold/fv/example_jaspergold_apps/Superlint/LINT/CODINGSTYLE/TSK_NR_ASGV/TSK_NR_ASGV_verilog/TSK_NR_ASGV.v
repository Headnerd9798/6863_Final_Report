module TSK_NR_ASGV (in1, in2, out1, out2);
   input in1;
   input in2;
   output out1;
   output out2;
   reg out1;
   reg g1;
   task task1;
      output o1;
      input in1;
      input in2;
      begin g1 = in1;
         o1 = in2;
      end
   endtask
   always @(in1 or in2) task1 (out1, in1, in2);
   assign out2 = g1;
endmodule
