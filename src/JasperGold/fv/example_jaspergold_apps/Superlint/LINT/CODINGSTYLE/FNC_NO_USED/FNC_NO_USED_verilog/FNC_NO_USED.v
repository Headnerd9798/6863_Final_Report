module FNC_NO_USED (in_a, in_b, out_a, out_b);
   input in_a;
   input in_b;
   output out_a;
   output out_b;
   reg out_a;
   reg g_a;
   function fnc_a;
      input in_b;
      begin
         fnc_a = in_b;
      end
   endfunction
   always @(in_a or in_b)
   out_a = in_a & in_b;
   assign out_b = g_a;
endmodule

