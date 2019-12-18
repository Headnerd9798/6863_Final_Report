module hash_core (
  input clk, rst_n,
  
  input [31:0] key,

  input in_valid,
  input [31:0] in_data,
  input [31:0] in_prev,
  
  output busy,
  
  output out_valid,
  output [31:0] out_hash
);

  reg [1:0] cnt;
  reg [31:0] data, prev;

  wire [31:0] key_rot_right;
  wire [31:0] key_rot_left;

  assign key_rot_right = {key[7:0],key[31:8]};
  assign key_rot_left = {key[23:0],key[31:24]};

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt <= 0;
    end else begin
      if (in_valid) begin
        cnt <= 1;
        data <= in_data;
        prev <= in_prev;
      end
      if (busy) begin
        data <= (prev ^ key_rot_right) + (data ^ ~key_rot_left);
        prev <= {data[23:0],data[31:24]};
        if (cnt == 2) begin
          cnt <= 2'b0;
        end else begin
          cnt <= cnt + 1'b1;
        end
      end
    end
  end

  assign out_valid = (cnt == 2);
  assign out_hash = data + prev;

  assign busy = (|cnt);

endmodule
