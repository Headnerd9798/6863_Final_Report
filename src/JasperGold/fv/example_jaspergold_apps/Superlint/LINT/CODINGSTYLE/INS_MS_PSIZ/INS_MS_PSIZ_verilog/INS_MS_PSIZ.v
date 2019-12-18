module INS_MS_PSIZ (data, outp);
   input data;
   output outp;
   submod m1 (.o(outp), .d(data));
endmodule
module submod(o, d);
   output o;
   input [1:0] d;
   assign o = d[1];
endmodule
