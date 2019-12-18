module hash_checker (
  input clk, rst_n,
  input s_req,
  input [11:0] s_addr,
  input s_write,
  input s_secure,
  input [31:0] s_wdata,
  input s_ack,
  input [31:0] s_rdata,
  input s_err
);

  localparam ADDR_CUSTOM_KEY     = 12'h400;
  localparam ADDR_KEY_SELECT     = 12'h401;
  localparam ADDR_OTP_PROG       = 12'h402;

  localparam ADDR_HASH_ADDR      = 12'h800;
  localparam ADDR_HASH_EXPECTED  = 12'h801;
  localparam ADDR_HASH_DATA      = 12'h802;
  localparam ADDR_HASH_START     = 12'h803;
  localparam ADDR_HASH_CLEAR     = 12'h804;
  localparam ADDR_HASH_STATUS    = 12'h805;

  localparam HASH_STATUS_BUSY    = 32'h0000_0001;
  localparam HASH_STATUS_PASS    = 32'h0000_0010;
  localparam HASH_STATUS_FAIL    = 32'h0000_1111;

  localparam KEY_SELECT_CUSTOM   = 1'b0;
  localparam KEY_SELECT_OTP      = 1'b1;

  enum reg [2:0] { IDLE, STARTED, DATA, DONE } hash_status;
  reg [4:0] hash_rem_data;
  reg hash_secure;
  reg [31:0] hash_expected;
  reg got_response;
  reg response_is_pass;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      hash_status = IDLE;
    end else begin
      case (hash_status)
        IDLE: begin
          // seen START -> register flags and reset got_response
          if (s_req & s_write & (s_addr == ADDR_HASH_START) & (~s_wdata[8] | s_secure) & s_ack & (s_wdata[4:0] > 0) & (s_wdata[4:0] <= 16)) begin
            hash_status = STARTED;
            hash_rem_data = s_wdata[4:0];
            hash_secure = s_wdata[8];
            got_response = 1'b0;
          end
        end
        STARTED: begin
          // seen EXPECTED -> register expected hash
          if (s_req & s_write & (s_addr == ADDR_HASH_EXPECTED) & (~hash_secure | s_secure) & s_ack) begin
            hash_status = DATA;
            hash_expected = s_wdata;
          end
        end
        DATA: begin
          // seen DATA -> decrement counter, if zero go to DONE
          if (s_req & s_write & (s_addr == ADDR_HASH_DATA) & (~hash_secure | s_secure) & s_ack) begin
            hash_rem_data--;
            if (hash_rem_data == 0) begin
              hash_status = DONE;
            end
          end
        end
        DONE: begin
          // seen STATUS -> register response (future responses must match this one)
          if (s_req & ~s_write & (s_addr == ADDR_HASH_STATUS) & (~hash_secure | s_secure) & s_ack & ((s_rdata == HASH_STATUS_PASS) | (s_rdata == HASH_STATUS_FAIL))) begin
            got_response = 1'b1;
            response_is_pass = (s_rdata == HASH_STATUS_PASS);
          end
        end
      endcase
      if (hash_status != IDLE & s_req & s_write & (s_addr == ADDR_HASH_CLEAR) & (~hash_secure | s_secure) & s_ack) begin
        hash_status = IDLE;
      end
    end
  end

  // invalid START command
  AST_invalid_start: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_START) & s_ack &
    ((hash_status != IDLE) | (s_wdata[8] & ~s_secure) | ~s_write | (s_wdata[4:0] == 0) | (s_wdata[4:0] > 16))
    |->
    s_err
  );

  // invalid EXPECTED write
  AST_invalid_wr_expected: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_EXPECTED) & s_ack & s_write &
    ((hash_status != STARTED) | (hash_secure & ~s_secure))
    |->
    s_err
  );

  // invalid EXPECTED read
  AST_invalid_expected_rd: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_EXPECTED) & s_ack & ~s_write &
    ((hash_status == IDLE) | (hash_status == STARTED) | (hash_secure & ~s_secure))
    |->
    s_err
  );

  // invalid DATA
  AST_invalid_data: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_DATA) & s_ack &
    ((hash_status != DATA) | (hash_secure & ~s_secure))
    |->
    s_err
  );

  // invalid STATUS
  AST_invalid_status: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_STATUS) & s_ack &
    ((hash_status == IDLE) | (hash_secure & ~s_secure) | s_write)
    |->
    s_err
  );

  // invalid CLEAR
  AST_invalid_clear: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_CLEAR) & s_ack &
    ((hash_status == IDLE) | (hash_secure & ~s_secure) | ~s_write)
    |->
    s_err
  );

  // before DONE the STATUS response must be busy
  AST_status_resp_busy: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_STATUS) & s_ack & ~s_write & (~hash_secure | s_secure) & (hash_status != DONE) & (hash_status != IDLE)
    |->
    ~s_err && (s_rdata == HASH_STATUS_BUSY)
  );

  // during DONE the response must be busy, pass, or fail
  AST_status_resp_done: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_STATUS) & s_ack & ~s_write & (~hash_secure | s_secure) & (hash_status == DONE)
    |->
    ~s_err && ((s_rdata == HASH_STATUS_BUSY) | (s_rdata == HASH_STATUS_FAIL) | (s_rdata == HASH_STATUS_PASS))
  );

  // if a previous STATUS was seen for the current hash, the response must be the same in future STATUS reads
  AST_status_resp_consistent: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & (s_addr == ADDR_HASH_STATUS) & s_ack & ~s_write & (~hash_secure | s_secure) & (hash_status == DONE) & got_response
    |->
    ~s_err && s_rdata == (response_is_pass ? HASH_STATUS_PASS : HASH_STATUS_FAIL)
  );

  // invalid key/OTP write
  AST_invalid_reg_wr: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & s_ack & s_write &
    ((s_addr == ADDR_CUSTOM_KEY) | (s_addr == ADDR_KEY_SELECT) | (s_addr == ADDR_OTP_PROG)) &
    (~s_secure | (hash_status != IDLE))
    |->
    s_err
  );

  // invalid key/OTP read
  AST_invalid_reg_rd: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req & s_ack & ~s_write &
    ((s_addr == ADDR_CUSTOM_KEY) | (s_addr == ADDR_KEY_SELECT) | (s_addr == ADDR_OTP_PROG)) &
    (~s_secure | (hash_status != IDLE) | (s_addr == ADDR_OTP_PROG))
    |->
    s_err
  );

  // maximum response delay
  AST_resp_delay: assert property (
    @(posedge clk) disable iff (~rst_n)
    s_req |-> ##[0:8] s_ack
  );

  // maximum delay to load OTP key
  AST_otp_key_delay: assert property (
    @(posedge clk) disable iff (~rst_n)
    ##8 hash.otp_key_valid
  );

  // FIFO checks
  AST_no_fifo_overflow: assert property (
    @(posedge clk) disable iff (~rst_n)
    hash.fifo_full |-> !hash.fifo_push
  );
  AST_no_fifo_underflow: assert property (
    @(posedge clk) disable iff (~rst_n)
    hash.fifo_empty |-> !hash.fifo_pop
  );

  // cover properties for different transaction lengths
  COV_hash_len_1_pass: cover property (
    @(posedge clk) disable iff (~rst_n | (hash_status == IDLE))
    hash_status == STARTED && hash_rem_data == 1
    ##[1:$]
    hash_status == DONE
    ##[1:$]
    s_req & (s_addr == ADDR_HASH_STATUS) & ~s_write & s_ack & ~s_err & ((s_rdata == HASH_STATUS_PASS) | (s_rdata == HASH_STATUS_FAIL))
  );
  COV_hash_len_16: cover property (
    @(posedge clk) disable iff (~rst_n | (hash_status == IDLE))
    hash_status == STARTED && hash_rem_data == 16
    ##[1:$]
    hash_status == DONE
    ##[1:$]
    s_req & (s_addr == ADDR_HASH_STATUS) & ~s_write & s_ack & ~s_err & ((s_rdata == HASH_STATUS_PASS) | (s_rdata == HASH_STATUS_FAIL))
  );

  // assume that CPU will keep all request signals stable until an ack comes
  ASM_req_stable: assume property (
    @(posedge clk) disable iff (~rst_n)
    s_req & ~s_ack
    |=>
    s_req &
    $stable(s_addr) &
    $stable(s_write) &
    $stable(s_secure) &
    $stable(s_wdata)
  );

endmodule


bind hash hash_checker hash_checker (.*);
