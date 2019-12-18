
//
// Wishbone interface constraints
//

bind uart_top wishbone_cons wishbone_cons (.*);


`include "uart_defines.v"

module wishbone_cons (

  wb_clk_i, wb_rst_i, wb_adr_i, wb_dat_i, wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o, wb_sel_i
       
  );
  
  parameter uart_data_width = `UART_DATA_WIDTH;
  parameter uart_addr_width = `UART_ADDR_WIDTH;

  input 			 wb_clk_i;
  input 			 wb_rst_i;
  input [uart_addr_width-1:0]  wb_adr_i;
  input [uart_data_width-1:0]	 wb_dat_i;
  input 			 wb_we_i;
  input 			 wb_stb_i;
  input 			 wb_cyc_i;
  input [3:0]	 wb_sel_i;
  input 			 wb_ack_o;

  property p_wb_never_invalid_request;
      @(posedge wb_clk_i) 
        not(!wb_cyc_i && wb_stb_i);
  endproperty 
  ASM_wb_never_invalid_request : assume property(p_wb_never_invalid_request);
 

  sequence s_wb_init_state;
    (!wb_cyc_i && !wb_stb_i);
  endsequence 

  sequence s_wb_mst_ready_state;
    (wb_cyc_i && !wb_stb_i); 
  endsequence 

  sequence s_wb_slv_ready_state;
    (wb_cyc_i && wb_stb_i);
  endsequence 

  property p_wb_init_next_state;
    @(posedge wb_clk_i) disable iff(wb_rst_i)
      s_wb_init_state |=> (s_wb_init_state or s_wb_mst_ready_state or s_wb_slv_ready_state);
  endproperty
  ASM_wb_init_next_state : assume property(p_wb_init_next_state); 
  
  property p_wb_mst_ready_next_state;
    @(posedge wb_clk_i) disable iff(wb_rst_i)
      s_wb_mst_ready_state |=> (s_wb_init_state or s_wb_mst_ready_state or s_wb_slv_ready_state);
  endproperty 
  ASM_wb_mst_ready_next_state : assume property(p_wb_mst_ready_next_state);

  property p_wb_slv_ready_next_state;
    @(posedge wb_clk_i) disable iff(wb_rst_i)
      (s_wb_slv_ready_state and wb_ack_o) |=> (s_wb_init_state or s_wb_mst_ready_state or s_wb_slv_ready_state);
  endproperty 
  ASM_wb_slv_ready_next_state : assume property(p_wb_slv_ready_next_state);
  
  property p_wb_slv_ready_hold_state;
    @(posedge wb_clk_i) disable iff(wb_rst_i)
      (s_wb_slv_ready_state and !wb_ack_o) |=> s_wb_slv_ready_state;
  endproperty 
  ASM_wb_slv_ready_hold_state : assume property(p_wb_slv_ready_hold_state);
  
  property p_wb_hold_bus (bus);
    @(posedge wb_clk_i) disable iff(wb_rst_i)
      (s_wb_slv_ready_state) |=> 
      ((bus == $past(bus)) && !wb_ack_o) or (wb_ack_o);
  endproperty 
  ASM_wb_hold_adr : assume property(p_wb_hold_bus(wb_adr_i));
  ASM_wb_hold_dat : assume property(p_wb_hold_bus(wb_dat_i));
  ASM_wb_hold_sel : assume property(p_wb_hold_bus(wb_sel_i));
  ASM_wb_hold_we : assume property(p_wb_hold_bus(wb_we_i));

endmodule 
