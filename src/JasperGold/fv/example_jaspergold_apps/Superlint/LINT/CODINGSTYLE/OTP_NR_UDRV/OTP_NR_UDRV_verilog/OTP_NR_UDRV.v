module OTP_NR_UDRV (clk,rst,port_a,port_b,port_c,port_d);
   input clk,rst,port_a;
   input [0:1] port_b;
   output [0:1] port_c;
   output port_d;
   reg [0:1] port_c;
   always @ (clk or rst or port_a)
   begin
      if (rst == 1'b1)
      port_c = 2'b00;
      else if (port_a)
      port_c = 2'b01;
      else if (clk)
      port_c = port_b;
   end
endmodule
