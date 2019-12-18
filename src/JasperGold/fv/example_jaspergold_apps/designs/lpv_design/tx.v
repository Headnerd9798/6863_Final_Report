//module tx (clk, reset, idle, pwr_up, tx_vld, tx_rdy, tx_data, tx_reqout, tx_req_rdy,  tx_din,
//           reg_wr, reg_data);
module tx (clk, reset, idle, tx_vld, tx_rdy, tx_data, tx_mem, tx_mem_rdy,  tx_mem_data,
           reg_wr, reg_data);

input clk, reset;

//from/to requesters
input tx_vld;
output [7:0] tx_data;
output tx_rdy;

//interface to power controller
//input pwr_up;
output idle;

//to/from memory controller
output tx_mem;
input tx_mem_rdy;
input[7:0] tx_mem_data;

input reg_wr;
input [7:0] reg_data;

reg [7:0] tx_data;
reg [6:0] idle_timer;
reg [6:0] idle_time;
reg tx_enable;
reg tx_rdy;
reg idle;
//wire tx_mem = tx_enable && pwr_up && tx_vld && !tx_rdy;
wire tx_mem = tx_enable && tx_vld && !tx_rdy;

always @(posedge clk or posedge reset)
    if (reset) tx_rdy <= 1'b0;
    else tx_rdy <= tx_mem_rdy;

always @(posedge clk or posedge reset)
    if (reset) {idle_time, tx_enable} <= 8'b10; //set idle_time to 1 to avoid initial shutdown
    else if (reg_wr) {idle_time, tx_enable} <= reg_data;

always @(posedge clk or posedge reset)
   if (reset)
         idle <= 1'b0;
   else  if (idle_timer == 8'd0 && !tx_vld)
         idle <= 1'b1;
   else  idle <= 1'b0;

always @(posedge clk or posedge reset)
   if (reset)
       idle_timer <= 7'd1; //set idle_time to 1 to avoid initial shutdown
   else if (tx_vld && tx_enable)
       idle_timer <= idle_time;
   else if (idle_timer != 7'd0)
       idle_timer <= idle_timer - 7'd1;

always @(posedge clk)
    if (tx_mem && tx_mem_rdy) tx_data <= tx_mem_data;

endmodule
