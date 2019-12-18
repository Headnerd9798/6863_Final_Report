//module rx (clk, reset, idle, pwr_up, rx_vld, rx_rdy, rx_data, rx_reqout, rx_req_rdy,  rx_dout, 
//           reg_wr, reg_data );

module rx (clk, reset, idle, rx_vld, rx_rdy, rx_data, rx_mem, rx_mem_rdy,  rx_mem_data, 
           reg_wr, reg_data );

input clk, reset;

//going to/from requestors
input rx_vld;
input [7:0] rx_data;
output rx_rdy;

//going to/from memory controller
output rx_mem;
input rx_mem_rdy;
output[7:0] rx_mem_data;

//register interfaces
input reg_wr;
input [7:0] reg_data;

//to/from power controller
output idle;
//input pwr_up;

//wire rx_rdy = pwr_up && rx_mem_rdy;
wire rx_rdy = rx_mem_rdy;
reg idle;
reg rx_mem;
reg [7:0] rx_mem_data;
reg [6:0] idle_timer;
reg [6:0] idle_time;
reg rx_enable;

always @(posedge clk or posedge reset)
    if (reset) {idle_time, rx_enable} <= 8'b10; //set idle_time to 1 to avoid initial shutdown
    else if (reg_wr) {idle_time, rx_enable} <= reg_data;

always @(posedge clk or posedge reset)
   if (reset)
         idle <= 1'b0;
   else  if (idle_timer == 8'd0 && !rx_vld) 
         idle <= 1'b1;
   else  idle <= 1'b0;


always @(posedge clk or posedge reset)
   if (reset)
       idle_timer <= 7'd1;  //set idle_time to 1 to avoid initial shutdown
   else if (rx_vld && rx_enable)
       idle_timer <= idle_time;
   else if (idle_timer != 7'd0)
       idle_timer <= idle_timer - 7'd1;


always @(posedge clk or posedge reset)
    if (reset)
        rx_mem <= 1'b0;
//    else if (rx_vld && pwr_up && rx_enable)
   else if (rx_vld && rx_enable)
       rx_mem <= ~rx_rdy; //we request until mem is ready
    else rx_mem <= 1'b0;
 

always @(posedge clk)
    if (rx_vld) rx_mem_data <= rx_data;

endmodule
