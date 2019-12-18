module otp_load (
  input clk, rst_n,

  output [31:0] otp_key,
  output otp_key_valid,

  output reg otp_read_en,
  output reg [1:0] otp_read_addr,
  input [7:0] otp_read_data
);

  reg [3:0] key_valid;
  reg [31:0] key;
  
  assign otp_key = key;
  assign otp_key_valid = (&key_valid);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      key_valid <= 4'b0000;
      otp_read_en <= 1'b0;
    end else begin
      if (otp_read_en) begin
        case (otp_read_addr)
          2'd0: begin
            key_valid[0] <= 1'b1;
            key[7:0] <= otp_read_data;
          end
          2'd1: begin
            key_valid[1] <= 1'b1;
            key[15:8] <= otp_read_data;
          end
          2'd2: begin
            key_valid[2] <= 1'b1;
            key[23:16] <= otp_read_data;
          end
          2'd3: begin
            key_valid[3] <= 1'b1;
            key[31:24] <= otp_read_data;
          end
        endcase
        otp_read_en <= 1'b0;
      end else begin
        casex (key_valid)
          4'bxxx0: begin
            otp_read_en <= 1'b1;
            otp_read_addr <= 2'd0;
          end
          4'bxx01: begin
            otp_read_en <= 1'b1;
            otp_read_addr <= 2'd1;
          end
          4'bx011: begin
            otp_read_en <= 1'b1;
            otp_read_addr <= 2'd2;
          end
          4'b0111: begin
            otp_read_en <= 1'b1;
            otp_read_addr <= 2'd3;
          end
        endcase
      end
    end
  end

endmodule
