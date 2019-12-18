module OPR_NR_WCCO (signal_a, signal_b, signal_c,signal_d);
   input logic signal_b, signal_c;
   output logic signal_a, signal_d;
   logic [3:0]signal_e;
   always_comb 
   begin
      signal_a = signal_b ==? signal_c; 
   end
   assign signal_d = signal_b inside {4'b0, signal_c};
   always_comb 
   begin
      for (int i = 0; i < 4; i++) begin
         signal_e[i] = signal_b inside {4'b0, i};
      end
   end
endmodule
