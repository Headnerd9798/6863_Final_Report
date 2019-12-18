module ALW_IS_TASK(clk, port_a, port_b, port_c, port_d);
   input clk; 
   input port_a, port_b; 
   output port_c, port_d;
   reg port_c, port_d;

   always @(posedge clk)
   begin 
      task_a(port_c, port_d, port_a,port_b);
   end

   task task_a; 
      output out_a, out_b; 
      input in_a, in_b;
      begin
         out_a = in_a ^ in_b;
         out_b = in_a & in_b;
      end
   endtask

endmodule
