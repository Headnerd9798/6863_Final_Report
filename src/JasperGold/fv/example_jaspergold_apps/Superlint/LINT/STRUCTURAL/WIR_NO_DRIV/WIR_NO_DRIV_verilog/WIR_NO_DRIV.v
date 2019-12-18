module WIR_NO_DRIV (in, clk, out);
   input in, clk;
   output reg out;
   lop l1(.in(in), .clk(clk), .out(out));
endmodule

module lop (in, clk, out);
   input in, clk;
   output reg out;
   wire a;
   cot c1(.in(in), .clk(clk), .out(a));
   assign out = a;
endmodule

module cot (in, clk, out);
   input in, clk;
   output out;
endmodule;
