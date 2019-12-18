module LOP_NR_FCND (outp, inp);
   output [3:0] outp;
   input [3:0] inp;
   reg [3:0] outp;
   integer i;
   always 
   begin
      for ( i=2; i<1; i=i+1 ) 
      begin
         outp = i;
      end
   end
endmodule
