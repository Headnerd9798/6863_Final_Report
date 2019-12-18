module TSK_NR_CLKE (clk, in0, out0);
   input clk, in0;
   output out0;
   reg out0;

   task task_a;
      input in1;
      output reg out1;
      begin
         @(posedge clk)
         begin
            out1 <= in1;
         end
      end
   endtask

   always@(posedge clk) 
   begin
      task_a(in0,out0);
   end
endmodule
