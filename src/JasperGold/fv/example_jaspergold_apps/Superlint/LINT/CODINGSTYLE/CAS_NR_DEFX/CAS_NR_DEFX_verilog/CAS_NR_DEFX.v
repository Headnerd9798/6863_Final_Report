module CAS_NR_DEFX (ip,sel,out);
   input ip, sel;
   output logic [1:0] out;
   always_comb begin
      case(sel)
         1'b0: out[0] = 1'b0;
         1'b1: out[1] = 1'b1;
         default: out[1] = 1'bx;
      endcase
   end
endmodule
