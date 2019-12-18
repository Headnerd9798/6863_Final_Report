module CLK_IS_MCDM (clock_a, clock_b, rst_n, data_in, data_out);
   input clock_a;
   input clock_b;
   input rst_n;
   output data_out;
   input data_in;
   reg data_out_meta;
   reg [1:0] data_out_reg;
   assign data_out = data_out_reg[1];
   always @ (posedge clock_a)
   begin
      data_out_meta <= data_in;
   end
   always @ (posedge clock_b or negedge rst_n)
   begin
      if (! rst_n)
      data_out_reg <= 'b0;
      else
      data_out_reg <= {data_out_reg[0], data_out_meta};
   end
endmodule

