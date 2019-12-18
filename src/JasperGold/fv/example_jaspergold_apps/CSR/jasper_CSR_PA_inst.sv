bind uart_top jasper_csr i_jasper_csr (.*);


`include "uart_defines.v"

module jasper_csr (
    wb_clk_i, wb_rst_i, 
    wb_adr_i, wb_dat_i, wb_dat_o, wb_dat8_o,wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o, wb_sel_i,
    int_o);

  parameter 	    uart_data_width = `UART_DATA_WIDTH;
  parameter 	    uart_addr_width = `UART_ADDR_WIDTH;

  input 			 wb_clk_i;
  input 			 wb_rst_i;
  input [uart_addr_width-1:0]  wb_adr_i;
  input [uart_data_width-1:0]	 wb_dat_i;
  input [uart_data_width-1:0]  wb_dat_o;
  input [uart_data_width-1:0]  wb_dat8_o;
  input 			 wb_we_i;
  input 			 wb_stb_i;
  input 			 wb_cyc_i;
  input [3:0]  wb_sel_i;
  input 			 wb_ack_o;
  input 			 int_o;

  //reg valid_addr_wr;
  //reg valid_addr_rd;
  wire valid_data_wr;
  wire valid_data_rd;
  reg rd_trans_started;
  reg wr_trans_started;
  reg [uart_addr_width-1:0] addr_sync;
        
  always@(posedge wb_clk_i) begin
    if (wb_rst_i || (!wb_cyc_i & !wb_stb_i)) begin  
      rd_trans_started <= 0;
      wr_trans_started <= 0;
      addr_sync <= 0;
    end
    else begin
      if (wb_ack_o) begin
        wr_trans_started <= 0;
        rd_trans_started <= 0;
      end
      else if (wb_stb_i & wb_cyc_i & wb_we_i & !wb_ack_o & !wr_trans_started) begin  
        wr_trans_started <= 1;  
        rd_trans_started <= 0;
        addr_sync <= wb_adr_i;
      end  
      else if (wb_stb_i & wb_cyc_i & !wb_we_i & !wb_ack_o & !rd_trans_started) begin 
        wr_trans_started <= 0;  
        rd_trans_started <= 1;
        addr_sync <= wb_adr_i;  
         
      end 
    end   
   end  

  assign valid_data_rd = rd_trans_started & wb_ack_o; 
  assign valid_data_wr = wb_stb_i & wb_cyc_i & wb_we_i & !wb_ack_o; 

  jasper_csr_checker
   #(.ADDR_WIDTH(uart_addr_width),
    .DATA_WIDTH(uart_data_width))
    jasper_csr_checker0 (
    .rstN(~wb_rst_i),
    .clk(wb_clk_i),
    .wr(valid_data_wr),
    .rd(valid_data_rd),
    .addr(addr_sync),
    .din(wb_dat_i),
    .dout(wb_dat8_o));

endmodule
