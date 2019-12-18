module fifo #(
  PTR_W = 4,
  DATA_W = 8,
  localparam SIZE = 2**PTR_W
) (
  input clk, rst_n,

  input push,
  input [DATA_W-1:0] data_in,
  input pop,
  output reg [DATA_W-1:0] data_out,

  output [PTR_W:0] level,
  output empty,
  output full

);

  logic [PTR_W:0] wrptr, rdptr;
  logic [DATA_W-1:0] mem [SIZE-1:0];

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wrptr <= 0;
      rdptr <= 0;
    end else begin
      if (push) begin
        mem[wrptr[PTR_W-1:0]] <= data_in;
        wrptr <= wrptr + 1'b1;
      end
      if (pop) begin
        rdptr <= rdptr + 1'b1;
      end
    end
  end

  assign data_out = mem[rdptr[PTR_W-1:0]];

  assign level = (wrptr - rdptr);
  assign empty = (level == 0);
  assign full = (level == SIZE);

endmodule
