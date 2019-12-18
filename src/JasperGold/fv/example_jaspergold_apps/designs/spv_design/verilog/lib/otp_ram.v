module otp_ram #(
  ADDR_W = 3,
  localparam SIZE = 2**ADDR_W
) (
  input clk,

  input read_en,
  input [ADDR_W-1:0] read_addr,
  output reg [7:0] read_data,

  input prog_en,
  input [ADDR_W-1:0] prog_addr,
  input [2:0] prog_bit,
  input prog_data
);

  logic [7:0] mem [SIZE-1:0];
  logic [7:0] programmed [SIZE-1:0];

  always @(posedge clk) begin
    if (prog_en && !programmed[prog_addr][prog_bit]) begin
      mem[prog_addr][prog_bit] <= prog_data;
      programmed[prog_addr][prog_bit] <= 1'b1;
    end
  end

  always @(posedge clk) begin
    if (read_en) begin
      read_data <= mem[read_addr];
    end
  end

endmodule
