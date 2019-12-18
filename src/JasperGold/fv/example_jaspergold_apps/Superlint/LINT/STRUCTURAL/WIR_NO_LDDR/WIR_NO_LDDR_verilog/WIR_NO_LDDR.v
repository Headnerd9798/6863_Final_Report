module WIR_NO_LDDR (in, out);
   input in;
   output out;
   reg a;
   bot b1(.in(in), .out(out));
endmodule

module bot (in, out);
   input in;
   output out;
endmodule;
