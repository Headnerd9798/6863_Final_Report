module FNC_NR_RETV (ip, op);
   input integer ip;
   output logic [1:0] op;

   function logic [1:0] func(input integer ip);
      return ip;
   endfunction

   assign op = func(ip);
endmodule
