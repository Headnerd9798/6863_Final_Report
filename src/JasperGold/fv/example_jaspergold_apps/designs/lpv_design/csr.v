//module csr (clk, reset, reg_datain, reg_dataout, reg_read, reg_wr, reg_addr,
//            reg_wr_pwr, reg_wr_rx1, reg_wr_rx2, reg_wr_tx1, reg_wr_tx2, reg_wr_mem, reg_mem_addr,
//            pwr_up);

module csr (clk, reset, reg_datain, reg_dataout, reg_read, reg_wr, reg_addr,
            reg_wr_pwr, reg_wr_rx1, reg_wr_rx2, reg_wr_tx1, reg_wr_tx2, reg_wr_mem, reg_mem_addr);

parameter PWR = 4'd0;
parameter RX1 = 4'd1;
parameter RX2 = 4'd2;
parameter TX1 = 4'd3;
parameter TX2 = 4'd4;
parameter MEM = 4'd5;

input clk, reset;
input reg_read;
//input pwr_up;
input [7:0] reg_datain;
output [7:0] reg_dataout;

input [5:0] reg_addr;
input reg_wr;

output reg_wr_pwr;
output reg_wr_rx1;
output reg_wr_rx2;
output reg_wr_tx1;
output reg_wr_tx2;
output reg_wr_mem;
output [2:0] reg_mem_addr;

reg [5:0] reg_wr_all;
wire reg_wr_pwr = reg_wr_all[0];
wire reg_wr_rx1 = reg_wr_all[1];
wire reg_wr_rx2 = reg_wr_all[2];
wire reg_wr_tx1 = reg_wr_all[3];
wire reg_wr_tx2 = reg_wr_all[4];

//LL need to register csr to memory
reg [2:0] temp_csr_mem_addrout;

reg [8:0] temp_csr_mem[0:4];

wire temp_csr_mem_empty = ~temp_csr_mem[0][8] & 
                          ~temp_csr_mem[1][8] &
                          ~temp_csr_mem[2][8] &
                          ~temp_csr_mem[3][8] &
                          ~temp_csr_mem[4][8];

//wire reg_wr_mem = pwr_up && (!temp_csr_mem_empty | reg_wr_all[5]);
//wire [2:0] reg_mem_addr = temp_csr_mem_empty?reg_addr[2:0]:temp_csr_mem_addrout;
//wire temp_csr_mem_wr = (!pwr_up && reg_wr_all[5]) || (pwr_up && reg_wr_all[5] && !temp_csr_mem_empty);

wire reg_wr_mem = !temp_csr_mem_empty | reg_wr_all[5];
wire [2:0] reg_mem_addr = temp_csr_mem_empty?reg_addr[2:0]:temp_csr_mem_addrout;
wire temp_csr_mem_wr = reg_wr_all[5] && !temp_csr_mem_empty;

reg [4:0] temp_set, temp_reset;

//LL need to work on
wire [7:0] reg_dataout = reg_wr_mem?((!temp_csr_mem_wr||(temp_csr_mem_wr && (reg_addr[2:0]==reg_mem_addr)))? reg_datain: temp_csr_mem[temp_csr_mem_addrout][7:0]):reg_datain;

always @*
  begin
      temp_set = 5'd0;
      temp_reset = 5'b11111;
      if (temp_csr_mem_wr) temp_set[reg_addr[2:0]] = 1'b1;
      if (reg_wr_mem) temp_reset[reg_mem_addr] = 1'b0;
  end
integer ii;
always @*
  begin
     temp_csr_mem_addrout = 3'd0;
     for (ii=0; ii<5; ii=ii+1)
        if (temp_csr_mem[ii][8]) temp_csr_mem_addrout = ii;
  end

always @(posedge clk) begin
        if (temp_csr_mem_wr) temp_csr_mem[reg_addr[2:0]][7:0] <= reg_datain;
     
end
always @(posedge clk or posedge reset)
        if (reset) begin
            temp_csr_mem[0][8] <= 1'b0;
            temp_csr_mem[1][8] <= 1'b0;
            temp_csr_mem[2][8] <= 1'b0;
            temp_csr_mem[3][8] <= 1'b0;
            temp_csr_mem[4][8] <= 1'b0;
        end
        else begin
           {temp_csr_mem[4][8], temp_csr_mem[3][8], temp_csr_mem[2][8], temp_csr_mem[1][8], temp_csr_mem[0][8]} <=
             (({temp_csr_mem[4][8], temp_csr_mem[3][8], temp_csr_mem[2][8], temp_csr_mem[1][8], temp_csr_mem[0][8]}|temp_set)&
                    temp_reset); 
       
        end

wire reg_wr_mem_tmp = reg_wr_all[5];

reg [7:0] reg_data;

always @(posedge clk)
    reg_data <= reg_datain;

always @(posedge clk or posedge reset)
    if (reset) begin
          reg_wr_all <= 6'd0;
    end
    else if (reg_wr) begin
       reg_wr_all[0] <= reg_addr[5:3]==3'd0;
       reg_wr_all[1] <= reg_addr[5:3]==3'd1;
       reg_wr_all[2] <= reg_addr[5:3]==3'd2;
       reg_wr_all[3] <= reg_addr[5:3]==3'd3;
       reg_wr_all[4] <= reg_addr[5:3]==3'd4;
       reg_wr_all[5] <= reg_addr[5:3]==3'd5;
    end
    else reg_wr_all <= 6'd0;
          

endmodule
