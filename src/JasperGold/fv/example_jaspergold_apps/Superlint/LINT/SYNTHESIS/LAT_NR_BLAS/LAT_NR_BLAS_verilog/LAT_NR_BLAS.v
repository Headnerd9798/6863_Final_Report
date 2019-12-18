module LAT_NR_BLAS (data, en, Q);
   input data, en;
   output Q;
   reg Q;
   always @(en or data)
   if (en)
   Q = data;
endmodule
