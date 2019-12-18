module MOD_NR_PRIM (clk, data, out1);
   input clk;
   input data;
   output out1;
   dff d1 (out1, clk, data);
endmodule
primitive dff (q, clk, d);
   output q;
   input clk, d;
   reg q;
   table
   (01) 0 : ? : 0 ;
   (01) 1 : ? : 1 ;
   (0?) 0 : 0 : 0 ;
   (0?) 1 : 1 : 1 ;
   (?0) ? : ? : - ;
   ? (??) : ? : - ;
   endtable
endprimitive
