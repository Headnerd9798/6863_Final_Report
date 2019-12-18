module MOD_NR_SYXZ (sel,port_a,port_b,port_c,port_d,port_e,outp);
   input sel,port_a,port_b,port_c,port_d;
   output port_e, outp;
   reg port_e, outp;
   always @(port_a or port_b or port_c or port_d)
   begin
      casez(port_d)
      2'b00: port_e = port_a;
      2'b01: port_e = port_b;
      2'b10: port_e = port_c;
      2'b11: port_e = 4'b00xx;
      default: port_e = 4'bx;
      endcase
   end
   always @(sel)
   begin
      if(sel == 1'b1)
      outp = 1'b1;
      else if(sel <= 1'b0)
      outp = 1'b0;
      else
      outp = 1'bx;
   end
endmodule
