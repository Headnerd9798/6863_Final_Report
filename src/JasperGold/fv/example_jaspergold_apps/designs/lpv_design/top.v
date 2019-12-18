module top (
	    input 	 clk, reset,

	    input 	 rx1_vld,
	    input [7:0]  rx1_data,
	    output 	 rx1_rdy,
	    input 	 rx2_vld,
	    input [7:0]  rx2_data,
	    output 	 rx2_rdy,

	    input 	 tx1_vld,
	    output [7:0] tx1_data,
	    output 	 tx1_rdy,
	    input 	 tx2_vld,
	    output [7:0] tx2_data,
	    output 	 tx2_rdy,

	    input 	 reg_wr,
	    input 	 reg_read,
	    input [7:0]  reg_datain,
	    output [7:0] reg_dataout,
	    input [5:0]  reg_addr
	    
	    );

   //power signals
   wire        pwr_up, iso_up, save, restore, vdd_net, vdd_sw_net;

   wire        rx1_idle;
   wire        rx1_mem_reqout;
   wire [7:0]  rx1_mem_dout;

   wire        rx2_idle;
   wire        rx2_mem_reqout;
   wire [7:0]  rx2_mem_dout;

   wire        tx1_idle;
   wire        tx1_mem_reqout;

   wire        tx2_idle;
   wire        tx2_mem_reqout;

   wire        rx1_mem_req_rdy, rx2_mem_req_rdy;
   wire        tx1_mem_req_rdy, tx2_mem_req_rdy;
   wire [7:0]  tx1_mem_dout, tx2_mem_dout;
 
   wire        reg_wr_pwr, reg_wr_rx1, reg_wr_rx2, reg_wr_tx1, reg_wr_tx2, reg_wr_mem;
   wire [2:0]  reg_mem_addr;

   rx rx1 (
	   .clk(clk),
	   .reset(reset),
	   // from/to outside
	   .rx_vld(rx1_vld), // in
	   .rx_data(rx1_data), // in 7:0
	   .rx_rdy(rx1_rdy), // out
	   // from/to memory
	   .rx_mem(rx1_mem_reqout), // out
	   .rx_mem_rdy(rx1_mem_req_rdy), // in
	   .rx_mem_data(rx1_mem_dout), // out 7:0
	   // csr
	   .reg_wr(reg_wr_rx1), // in
	   .reg_data(reg_dataout), // in 7:0
	   // power
	   .idle(rx1_idle) // out
	   );
   rx rx2 (
	   .clk(clk),
	   .reset(reset),
	   // from/to outside
	   .rx_vld(rx2_vld), // in
	   .rx_data(rx2_data), // in 7:0
	   .rx_rdy(rx2_rdy), // out
	   // from/to memory
	   .rx_mem(rx2_mem_reqout), // out
	   .rx_mem_rdy(rx2_mem_req_rdy), // in
	   .rx_mem_data(rx2_mem_dout), // out 7:0
	   // csr
	   .reg_wr(reg_wr_rx2), // in
	   .reg_data(reg_dataout), // in 7:0
	   // power
	   .idle(rx2_idle) // out
	   );
   tx tx1 (
	   .clk(clk),
	   .reset(reset),
	   // from/to outside
	   .tx_vld(tx1_vld), // in
	   .tx_data(tx1_data), // out 7:0
	   .tx_rdy(tx1_rdy), // out
	   // from/to  memory
	   .tx_mem(tx1_mem_reqout), // out
	   .tx_mem_rdy(tx1_mem_req_rdy), // in
	   .tx_mem_data(tx1_mem_dout), // in 7:0
	   // csr
	   .reg_wr(reg_wr_tx1), // in
	   .reg_data(reg_dataout), // in 7:0
	   // power
	   .idle(tx1_idle) // out
	   );
   tx tx2 (
	   .clk(clk),
	   .reset(reset),
	   // from/to outside
	   .tx_vld(tx2_vld), // in
	   .tx_data(tx2_data), // out 7:0
	   .tx_rdy(tx2_rdy), // out
	   // from/to  memory
	   .tx_mem(tx2_mem_reqout), // out
	   .tx_mem_rdy(tx2_mem_req_rdy), // in
	   .tx_mem_data(tx2_mem_dout), // in 7:0
	   // csr
	   .reg_wr(reg_wr_tx2), // in
	   .reg_data(reg_dataout), // in 7:0
	   // power
	   .idle(tx2_idle) // out
	   );
   csr csr (
	    .clk(clk),
	    .reset(reset),
	    // from/to outside
	    .reg_read(reg_read), // in
	    .reg_datain(reg_datain), // in 7:0
	    .reg_dataout(reg_dataout), // out 7:0
	    .reg_addr(reg_addr), // in 5:0
	    .reg_wr(reg_wr), // in
	    // from/to other blocks
	    .reg_wr_pwr(reg_wr_pwr), // out
	    .reg_wr_rx1(reg_wr_rx1), // out
	    .reg_wr_rx2(reg_wr_rx2), // out
	    .reg_wr_tx1(reg_wr_tx1), // out
	    .reg_wr_tx2(reg_wr_tx2), // out
	    .reg_wr_mem(reg_wr_mem), // out
	    .reg_mem_addr(reg_mem_addr) // out 2:0
	    );
   mem_ctrl mem_ctrl (
		      .clk(clk),
		      .reset(reset),
		      // from/to rx
		      .req_rx1(rx1_mem_reqout), // in
		      .req_rx2(rx2_mem_reqout), // in
		      .rx_ack1(rx1_mem_req_rdy), // out
		      .rx_ack2(rx2_mem_req_rdy), // out
		      .rx_din1(rx1_mem_dout), // in 7:0
		      .rx_din2(rx2_mem_dout), // in 7:0
		      // from/to tx
		      .req_tx1(tx1_mem_reqout), // in
		      .req_tx2(tx2_mem_reqout), // in
		      .tx_ack1(tx1_mem_req_rdy), // out
		      .tx_ack2(tx2_mem_req_rdy), // out
		      .tx_dout1(tx1_mem_dout), // out 7:0
		      .tx_dout2(tx2_mem_dout), // out 7:0
		      // csr
		      .wr(reg_wr_mem), // in
		      .reg_addr(reg_mem_addr), // in 2:0
		      .din(reg_dataout), // in 7:0
		      .dout(), // out 7:0
		      // power
		      .iso_up(iso_up), // in
		      .pwr_up(pwr_up), // in
		      .save(save),     // in
		      .restore(restore)// in
		      );
   pwr_ctrl pwr_ctrl (
		      .clk(clk),
		      .reset(reset),
		      // from tx/rx blocks
		      .idle1(rx1_idle), // in
		      .idle2(rx2_idle), // in
		      .idle3(tx1_idle), // in
		      .idle4(tx2_idle), // in
		      // from/to csr
		      .csr_mem(reg_wr_mem), // in
		      .reg_wr(reg_wr_pwr), // in
		      .reg_data(reg_dataout[5:0]), // in 5:0
		      // power signals
		      .iso_up(iso_up), // out
		      .pwr_up(pwr_up), // out
		      .save(save),     // out
		      .restore(restore)// out
		      );


rx1_data_stable:   assume    property (@(posedge clk) (rx1_vld && !rx1_rdy |=> rx1_vld && $stable(rx1_data)));
rx2_data_stable:   assume    property (@(posedge clk) (rx2_vld && !rx2_rdy |=> rx2_vld && $stable(rx2_data)));
                                 
rx1_idle_time_ub:   assume      property (@(posedge clk) (rx1.idle_time<7'd16));
rx2_idle_time_ub:   assume      property (@(posedge clk) (rx2.idle_time<7'd16));
tx1_idle_time_ub:   assume      property (@(posedge clk) (tx1.idle_time<7'd16));
tx2_idle_time_ub:   assume      property (@(posedge clk) (tx2.idle_time<7'd16));
                
pwr_ctrl_pwr_reg:   assume   property (@(posedge clk) (pwr_ctrl.pwr_reg<4'd8));

efficiency:         assert   property (@(posedge clk) ((~mem_ctrl.temp_empty|mem_ctrl.req_rx)&&~mem_ctrl.req_tx |-> ##[0:1] mem_ctrl.mem_wr));

endmodule


