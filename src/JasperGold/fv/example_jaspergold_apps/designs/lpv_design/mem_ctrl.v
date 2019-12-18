module mem_ctrl (clk, reset, 
		 req_rx1, rx_ack1, rx_din1, 
		 req_rx2, rx_ack2, rx_din2, 
		 req_tx1, tx_ack1, tx_dout1, 
		 req_tx2, tx_ack2, tx_dout2,
                 reg_addr, wr, din, dout, 
		 iso_up, pwr_up, save, restore);

   input clk, reset;
   //from/to rx
   input req_rx1, req_rx2;
   output rx_ack1, rx_ack2;
   input [7:0] din, rx_din1, rx_din2;
   
   //from/to tx
   input       req_tx1, req_tx2;
   output      tx_ack1, tx_ack2;
   output [7:0] dout, tx_dout1, tx_dout2;

   //from power-controller
   input 	iso_up, pwr_up, save, restore; //unconnected

   //from csr
   input 	wr;
   input [2:0] 	reg_addr;
   
   //temp fifo for write in case the memory is busy with reads
   reg [8:0] 	temp_wrdata[0:3];
   reg 		temp_full, temp_empty;
   reg 		rx_ack1;
   reg 		rx_ack2;
   reg 		tx_ack1;
   reg 		tx_ack2;
   
   //configuration of link address space
   reg [7:0] 	link1_addr;
   reg [7:0] 	link2_addr;
   reg [7:0] 	link1_size;
   reg [7:0] 	link2_size;
   reg 		link1_en;
   reg 		link2_en;
   wire [7:0] 	dout;

   wire 	req_rx1_new = req_rx1 && !rx_ack1 && link1_en;
   wire 	req_rx2_new = req_rx2 && !rx_ack2 && link2_en;
   wire 	req_tx1_new = req_tx1 && !tx_ack1 && link1_en;
   wire 	req_tx2_new = req_tx2 && !tx_ack2 && link2_en;

   wire 	req_tx = req_tx1_new | req_tx2_new;
   wire 	req_rx = req_rx1_new | req_rx2_new;
   wire 	temp_we = ~temp_full && req_rx && (!temp_empty|req_tx);
   reg [1:0] 	temp_wptr, temp_rptr;
   wire 	grant_rx = req_rx && !req_tx;
   wire 	grant_tx = req_tx;
   
   wire 	mem_wr = (grant_rx && temp_empty) || (!grant_tx && !temp_empty);
   wire 	temp_pop = !grant_tx && !temp_empty;
   wire [1:0] 	diff_rw = temp_wptr - temp_rptr;
   wire [7:0] 	mem_dout;

   //which rx/tx port is being served
   reg 		tx_toggle, rx_toggle;
   
   
   always @(posedge clk or posedge reset)
     if (reset) begin
        temp_wptr <= 2'b0;
        temp_rptr <= 2'b0;
        temp_empty <= 1'b1;
        temp_full <= 1'b0;
     end
     else begin
        if (temp_we) begin
           temp_wptr <= temp_wptr + 2'd1;
           if ((diff_rw==2'd3) && !temp_pop)
             temp_full <= 1'b1;
           if (temp_empty && !temp_pop)
             temp_empty <= 1'b0;
        end     
        if (temp_pop) begin
           temp_rptr <= temp_rptr + 2'd1;
           if (diff_rw==2'd1 && !temp_we)
             temp_empty <= 1'b1;
           if (!temp_we)
             temp_full <= 1'b0;
        end
     end
   
   reg [8:0] write_data;
   
   always @* 
     begin
        if (~req_rx1_new) write_data = {1'b1, rx_din2};
        else if (~req_rx2_new) write_data = {1'b0, rx_din1};
        else if (~rx_toggle) write_data = {1'b0, rx_din1};
        else write_data = {1'b1, rx_din2};
     end
   
   always @(posedge clk)
     if (temp_we) begin
        temp_wrdata[temp_wptr] <= write_data;
     end
   
   //arbitration
   
   always @(posedge clk or posedge reset)
     if (reset) begin
        rx_ack1 <= 1'b0;
        rx_ack2 <= 1'b0;
        tx_ack1 <= 1'b0;
        tx_ack2 <= 1'b0;
     end
     else begin
        rx_ack1 <= (~req_rx2_new|~rx_toggle) && 
		   (temp_we||(temp_empty&&mem_wr)) && 
		   req_rx1_new && link1_en;
        rx_ack2 <= (~req_rx1_new|rx_toggle) && 
		   (temp_we||(temp_empty&&mem_wr)) && 
		   req_rx2_new && link2_en;
        tx_ack1 <= ~tx_toggle && grant_tx && req_tx1_new && link1_en;
        tx_ack2 <= tx_toggle && grant_tx && req_tx2_new && link2_en;
     end
   
   reg [7:0] tx_dout1;
   reg [7:0] tx_dout2;
   
   wire [7:0] rx_din = (~req_rx2_new|(~rx_toggle&req_rx1_new))? rx_din1:rx_din2;
   wire [8:0] temp_dout = temp_wrdata[temp_rptr];
   wire [7:0] mem_din = temp_empty?rx_din:temp_dout[7:0];


   always @(posedge clk)
     begin
	tx_dout2 <= mem_dout;
	tx_dout1 <= mem_dout;
     end
   
   always @(posedge clk or posedge reset)
     if (reset) begin
	tx_toggle <= 1'b0;
        rx_toggle <= 1'b0;
     end
     else begin
	if (grant_tx) begin
           if (!req_tx1_new) tx_toggle <= 1'b0;
           else if (!req_tx2_new) tx_toggle <= 1'b1;
           else tx_toggle <= ~tx_toggle;
	end
	if ((grant_rx && temp_empty)|temp_we) begin
           if (!req_rx1_new) tx_toggle <= 1'b0;
           else if (!req_rx2_new) tx_toggle <= 1'b1;
           else rx_toggle <= ~rx_toggle;
	end
     end
   
   always @(posedge clk)
     if (wr) begin
	if (reg_addr==3'b0) link1_addr <= din;
	else if (reg_addr==3'b01) link2_addr <= din;
	else if (reg_addr==3'b10) link1_size <= din;
	else if (reg_addr==3'b11) link2_size <= din;
     end
   
   always @(posedge clk or posedge reset)
     if (reset) {link1_en, link2_en} <= 2'b00;
     else if (wr && reg_addr==3'b100)
       {link1_en, link2_en} <= din[1:0];
   
   reg [7:0] link1_rx_cnt;
   reg [7:0] link2_rx_cnt;
   reg [7:0] link1_tx_cnt;
   reg [7:0] link2_tx_cnt;
   wire      tx1_sel = grant_tx && ~tx_toggle;
   wire      tx2_sel = grant_tx && tx_toggle;
   wire      rx1_sel = (grant_rx && (~req_rx2_new|~rx_toggle))||(temp_pop&&~temp_dout[8]);
   wire      rx2_sel = (grant_rx && (~req_rx1_new|rx_toggle))||(temp_pop&&temp_dout[8]);
   
   always @(posedge clk or posedge reset)
     if (reset) begin
        link1_rx_cnt <= 8'b0;
        link2_rx_cnt <= 8'b0;
        link1_tx_cnt <= 8'b0;
        link2_tx_cnt <= 8'b0;
     end
     else begin
        if (tx1_sel) link1_tx_cnt <= link1_tx_cnt + 8'd1;
        else if (tx2_sel) link2_tx_cnt <= link2_tx_cnt + 8'd1;
        else if (rx1_sel) link1_rx_cnt <= link1_rx_cnt + 8'd1;
        else if (rx2_sel) link2_rx_cnt <= link1_rx_cnt + 8'd1;
     end
   
   reg [7:0] mem_addr;
   
   always @* begin
      mem_addr = 8'd0;
      if (tx1_sel) mem_addr = link1_tx_cnt + link1_addr;
      else if (tx2_sel) mem_addr = link2_tx_cnt + link2_addr;
      else if (rx1_sel) mem_addr = link1_tx_cnt + link1_addr;
      else if (rx2_sel) mem_addr = link2_tx_cnt + link2_addr;
   end
   
   mem256x8 mem1(.clk(clk), 
		 .reset(reset), 
		 .din(mem_din), 
		 .dout(mem_dout), 
		 .addr(mem_addr), 
		 .we(mem_wr));
        
endmodule

module mem256x8 (clk, reset, din, dout, addr, we);
   input clk, reset;
   input [7:0] addr;
   input       we;
   input [7:0] din;
   output [7:0] dout;
   
endmodule
