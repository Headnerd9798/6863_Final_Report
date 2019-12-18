module VAR_NO_INTL (port_a,port_b);
   output [15:0] port_a;
   input [15:0] port_b;
   reg [15:0] var_a;
   integer loop_index;
   integer var_count;
   always_comb
   begin : abc
      var_count = 0;
      for(; loop_index <= 15; loop_index++)
      begin
         var_a[loop_index] = port_b[loop_index - 1] + 1;
         var_count++;
         if(var_count == 10)
         break;
      end
   end
   assign port_a = ~var_a;
endmodule
