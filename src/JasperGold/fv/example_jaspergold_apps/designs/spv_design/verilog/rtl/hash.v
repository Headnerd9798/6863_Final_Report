`include "defines.vh"

module hash (
  input clk, rst_n,
  input s_req,
  input [11:0] s_addr,
  input s_write,
  input s_secure,
  input [31:0] s_wdata,
  output reg s_ack,
  output reg [31:0] s_rdata,
  output reg s_err
);

  reg key_select_load, custom_key_load;
  reg key_select;
  reg [31:0] custom_key;

  wire [31:0] otp_key;
  wire otp_key_valid;
  
  wire otp_read_en;
  wire [1:0] otp_read_addr;
  wire [7:0] otp_read_data;

  reg otp_prog_load;
  reg otp_prog_en;
  reg [1:0] otp_prog_addr;
  reg [2:0] otp_prog_bit;
  reg otp_prog_data;

  reg [31:0] s_rdata_prev;
  reg s_err_prev;

  wire [31:0] key;

  wire hash_busy, hash_out_valid;
  wire [31:0] hash_value_next;

  reg hash_start, hash_active, hash_clear, hash_expected_valid, hash_secure_only, hash_expected_load;
  reg [31:0] hash_expected_value, hash_value;
  reg [4:0] hash_data_left, hash_data_left_next, hash_proc_left;
  
  wire fifo_pop, fifo_push, fifo_empty, fifo_full;

  wire [31:0] fifo_data_out, fifo_data_in;

  
  assign fifo_pop = ~fifo_empty & ~hash_busy;
`ifdef FIX1
  assign fifo_push = s_req & (s_addr == `ADDR_HASH_DATA) & s_write &
                     hash_active & hash_expected_valid & (~hash_secure_only | s_secure) &
                     (hash_data_left > 0) &
                     ~fifo_full;
`else
  assign fifo_push = s_req & (s_addr == `ADDR_HASH_DATA) & s_write &
                     hash_active & hash_expected_valid & (~hash_secure_only | s_secure) &
                     (hash_data_left > 0);
`endif
  assign fifo_data_in = s_wdata;
  
  assign key = (key_select == `KEY_SELECT_OTP) ? otp_key : custom_key;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      hash_active <= 1'b0;
      custom_key <= 32'b0;
      key_select <= `KEY_SELECT_OTP;
      otp_prog_en <= 1'b0;
    end else begin
      if (hash_start) begin
        hash_active <= 1'b1;
        hash_secure_only <= s_wdata[8];
        hash_active <= 1'b1;
        hash_expected_valid <= 1'b0;
        hash_data_left <= s_wdata[4:0];
        hash_proc_left <= s_wdata[4:0];
        hash_value <= 32'b0;
      end
      if (hash_expected_load) begin
        hash_expected_valid <= 1'b1;
        hash_expected_value <= s_wdata;
      end
      if (hash_clear) begin
        hash_active <= 1'b0;
      end
      if (custom_key_load) begin
        custom_key <= s_wdata;
      end
      if (key_select_load) begin
        key_select <= s_wdata[0];
      end
      if (otp_prog_load) begin
        otp_prog_en <= 1'b1;
        otp_prog_addr <= s_wdata[17:16];
        otp_prog_bit <= s_wdata[10:8];
        otp_prog_data <= s_wdata[0];
      end else begin
        otp_prog_en <= 1'b0;
      end
      if (fifo_push) begin
        hash_data_left <= (hash_data_left - 1'b1);
      end
      if (hash_active & hash_out_valid) begin
        hash_value <= hash_value_next;
        hash_proc_left <= (hash_proc_left - 1'b1);
      end
      s_rdata_prev <= s_rdata;
      s_err_prev <= s_err;
    end
  end

  always_comb begin
    s_ack = 1'b0;
    s_err = s_err_prev;
    s_rdata = s_rdata_prev;
    hash_start = 1'b0;
    hash_expected_load = 1'b0;
    hash_clear = 1'b0;
    otp_prog_load = 1'b0;
    custom_key_load = 1'b0;
    key_select_load = 1'b0;
    hash_data_left_next = hash_data_left;
    if (s_req) begin
      case (s_addr)
        `ADDR_HASH_START: begin
          if (~s_write | hash_active | (s_wdata[8] & ~s_secure) | (s_wdata[4:0] == 0) | (s_wdata[4:0] > 16)) begin
            s_ack = 1'b1;
            s_err = 1'b1;
          end else if ((key_select == `KEY_SELECT_CUSTOM) | otp_key_valid) begin
            s_ack = 1'b1;
            s_err = 1'b0;
            hash_start = 1'b1;
          end
        end
        `ADDR_HASH_EXPECTED: begin
          if (~hash_active | (hash_secure_only & ~s_secure) | (~s_write & ~hash_expected_valid) | (s_write & hash_expected_valid)) begin
            s_ack = 1'b1;
            s_err = 1'b1;
          end else begin
            if (s_write) begin
              hash_expected_load = 1'b1;
            end
            s_rdata = hash_expected_value;
            s_ack = 1'b1;
          end
        end
        `ADDR_HASH_DATA: begin
          if (~s_write | ~hash_active | ~hash_expected_valid | (hash_secure_only & ~s_secure) | (hash_data_left == 0)) begin
            s_ack = 1'b1;
            s_err = 1'b1;
          end else if (~fifo_full) begin
            hash_data_left_next = (hash_data_left - 1'b1);
            s_ack = 1'b1;
            s_err = 1'b0;
          end
        end
        `ADDR_HASH_STATUS: begin
          if (s_write | ~hash_active | (hash_secure_only & ~s_secure)) begin
            s_ack = 1'b1;
            s_err = 1'b1;
          end else begin
            s_ack = 1'b1;
`ifdef FIX2
            s_err = 1'b0;
`endif
            if (hash_proc_left == 0) begin
              s_rdata = (hash_value == hash_expected_value) ? `HASH_STATUS_PASS : `HASH_STATUS_FAIL;
            end else begin
              s_rdata = `HASH_STATUS_BUSY;
            end
          end
        end
        `ADDR_HASH_CLEAR: begin
          if (~s_write | ~hash_active | (hash_secure_only & ~s_secure)) begin
            s_ack = 1'b1;
            s_err = 1'b1;
          end else begin
            s_ack = 1'b1;
            s_err = 1'b0;
            hash_clear = 1'b1;
          end
        end
        `ADDR_KEY_SELECT: begin
          if (hash_active | ~s_secure) begin
            s_ack = 1'b1;
            s_err = 1'b1;
          end else begin
            s_ack = 1'b1;
            s_err = 1'b0;
            s_rdata = key_select;
            if (s_write) begin
              key_select_load = 1'b1;
            end
          end
        end
        `ADDR_CUSTOM_KEY: begin
          if (hash_active | ~s_secure) begin
            s_ack = 1'b1;
            s_err = 1'b1;
          end else begin
            s_ack = 1'b1;
            s_err = 1'b0;
            s_rdata = custom_key;
            if (s_write) begin
              custom_key_load = 1'b1;
            end
          end
        end
        `ADDR_OTP_PROG: begin
          if (~s_write | hash_active | ~s_secure) begin
            s_ack = 1'b1;
            s_err = 1'b1;
          end else begin
            otp_prog_load = 1'b1;
            s_ack = 1'b1;
            s_err = 1'b0;
          end
        end
        default: begin
          s_ack = 1'b1;
          s_err = 1'b1;
        end
      endcase
    end
  end

  hash_core hash_core (
    .clk(clk), .rst_n(rst_n & ~hash_clear),
    .key(key),
    .in_valid(fifo_pop),
    .in_data(fifo_data_out),
    .in_prev(hash_value),
    .busy(hash_busy),
    .out_valid(hash_out_valid),
    .out_hash(hash_value_next)
  );

  fifo #(3,32) fifo (
    .clk(clk), .rst_n(rst_n & ~hash_clear),
    .push(fifo_push),
    .data_in(fifo_data_in),
    .pop(fifo_pop),
    .data_out(fifo_data_out),
    .level(),
    .empty(fifo_empty),
    .full(fifo_full)
  );

 otp_ram #(.ADDR_W(2)) otp_ram (
    .clk(clk),
    .read_en(otp_read_en),
    .read_addr(otp_read_addr),
    .read_data(otp_read_data),
    .prog_en(otp_prog_en),
    .prog_addr(otp_prog_addr),
    .prog_bit(otp_prog_bit),
    .prog_data(otp_prog_data) 
  );
  
  otp_load otp_load (
    .clk(clk), .rst_n(rst_n),
    .otp_key(otp_key),
    .otp_key_valid(otp_key_valid),
    .otp_read_en(otp_read_en),
    .otp_read_addr(otp_read_addr),
    .otp_read_data(otp_read_data)
  );

endmodule
