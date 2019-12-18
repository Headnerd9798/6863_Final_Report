module MOD_NR_CASX (in_a,out_a);
   input [1:0] in_a;
   output [1:0] out_a;

   function func_a;
      input [1:0] port_a;
      reg reg_a; 
      begin
         casex(reg_a)
         1'b0: port_a = 2'b00;
         1'b1: port_a = 2'b10;
         1'bx: port_a = 2'b01;
         1'bz: port_a = 2'b11;
      endcase
   end
endfunction

assign out_a = func_a (in_a);
endmodule
