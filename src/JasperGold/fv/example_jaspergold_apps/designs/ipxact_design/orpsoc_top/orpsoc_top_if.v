//////////////////////////////////////////////////////////////////////
///                                                               //// 
/// ORPSoC top level                                              ////
///                                                               ////
/// Define I/O ports, instantiate modules                         ////
///                                                               ////
/// Julius Baxter, julius@opencores.org                           ////
///                                                               ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2009, 2010 Authors and OPENCORES.ORG           ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "orpsoc-defines.v"

module orpsoc_top
  ( 
`ifdef JTAG_DEBUG    
    tdo_pad_o, tms_pad_i, tck_pad_i, tdi_pad_i,
`endif     
`ifdef UART0
    uart0_srx_pad_i, uart0_stx_pad_o, 
`endif
    clk_pad_i,
    rst_n_pad_i, haddr, htrans, hwrite, hsize, hburst,
	hsel, hwdata, hrdata, hresp, hready, hprot
    );

`include "orpsoc-params.v"   

   input clk_pad_i;
   input rst_n_pad_i;
   
`ifdef JTAG_DEBUG    
   output tdo_pad_o;
   input  tms_pad_i;
   input  tck_pad_i;
   input  tdi_pad_i;
`endif
`ifdef UART0
   input  uart0_srx_pad_i;
   output uart0_stx_pad_o;
`endif

	input [wb_dw-1:0]hwdata;						// data bus		
	input hwrite;									// write/read enable
	input [2:0]hburst;								// burst type
	input [2:0]hsize;								// data size
	input [1:0]htrans;								// type of transfer
	input [3:0]hprot;								// type of transfer
	input hsel;										// slave select 
	input [wb_aw-1:0]haddr;						// address bus
	output [wb_dw-1:0]hrdata;						// data output for wishbone slave
	output [1:0]hresp;								// response signal from slave
	output hready;									// slave ready
   
   ////////////////////////////////////////////////////////////////////////
   //
   // Clock and reset generation module
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire   async_rst;
   wire   wb_clk, wb_rst;
   wire   dbg_tck;

   
   clkgen clkgen0
     (

      .clk_pad_i             (clk_pad_i),

      .async_rst_o            (async_rst),
      
      .wb_clk_o                  (wb_clk),
      .wb_rst_o                  (wb_rst),

`ifdef JTAG_DEBUG
      .tck_pad_i                 (tck_pad_i),
      .dbg_tck_o                 (dbg_tck),
`endif      

      // Asynchronous active low reset
      .rst_n_pad_i               (rst_n_pad_i)
      );

   
   ////////////////////////////////////////////////////////////////////////
   //
   // Arbiter
   // 
   ////////////////////////////////////////////////////////////////////////
   
   // Wire naming convention:
   // First: wishbone master or slave (wbm/wbs)
   // Second: Which bus it's on instruction or data (i/d)
   // Third: Between which module and the arbiter the wires are
   // Fourth: Signal name
   // Fifth: Direction relative to module (not bus/arbiter!)
   //        ie. wbm_d_or12_adr_o is address OUT from the or1200

   // OR1200 instruction bus wires
   wishbone #(.ADDR_WID(wb_aw), .DATA_WID(wb_dw)) wbm_i_or12;
   wishbone #(.ADDR_WID(wb_aw), .DATA_WID(wb_dw)) wbm_d_or12;
   
   wishbone #(.ADDR_WID(wb_aw), .DATA_WID(wb_dw)) wbm_d_dbg;
   wishbone #(.ADDR_WID(wb_aw), .DATA_WID(wb_dw)) wbm_b_d;
   
   // OR1200 data bus wires   

   // Debug interface bus wires   

   // Byte bus bridge master signals

   // Instruction bus slave wires //
   
   // rom0 instruction bus wires
   wishbone #(.ADDR_WID(32), .DATA_WID(wbs_i_rom0_data_width)) wbs_i_rom;

   wishbone #(.ADDR_WID(32), .DATA_WID(32)) wbs_i_mc0;

   // mc0 instruction bus wires
   
   // Data bus slave wires //
   
   // mc0 data bus wires
   wishbone #(.ADDR_WID(32), .DATA_WID(32)) wbs_d_mc0;

   wishbone #(.ADDR_WID(32), .DATA_WID(wbs_d_uart0_data_width)) wbs_d_uart0;
   wishbone #(.ADDR_WID(32), .DATA_WID(8))  wbs_d_intgen;

   //
   // Wishbone instruction bus arbiter
   //
   
   arbiter_ibus arbiter_ibus0
     (
      // Instruction Bus Master
      // Inputs to arbiter from master
      .wbm_adr_o			(wbm_i_or12.adr),
      .wbm_dat_o			(wbm_i_or12.dat_wr),
      .wbm_sel_o			(wbm_i_or12.sel),
      .wbm_we_o				(wbm_i_or12.we),
      .wbm_cyc_o			(wbm_i_or12.cyc),
      .wbm_stb_o			(wbm_i_or12.stb),
      .wbm_cti_o			(wbm_i_or12.cti),
      .wbm_bte_o			(wbm_i_or12.bte),
      // Outputs to master from arbiter
      .wbm_dat_i			(wbm_i_or12.dat_rd),
      .wbm_ack_i			(wbm_i_or12.ack),
      .wbm_err_i			(wbm_i_or12.err),
      .wbm_rty_i			(wbm_i_or12.rty),
      
      // Slave 0
      // Inputs to slave from arbiter
      .wbs0_adr_i			(wbs_i_rom0.adr),
      .wbs0_dat_i			(wbs_i_rom0.dat_wr),
      .wbs0_sel_i			(wbs_i_rom0.sel),
      .wbs0_we_i			(wbs_i_rom0.we),
      .wbs0_cyc_i			(wbs_i_rom0.cyc),
      .wbs0_stb_i			(wbs_i_rom0.stb),
      .wbs0_cti_i			(wbs_i_rom0.cti),
      .wbs0_bte_i			(wbs_i_rom0.bte),
      // Outputs from slave to arbiter      
      .wbs0_dat_o			(wbs_i_rom0.dat_rd),
      .wbs0_ack_o			(wbs_i_rom0.ack),
      .wbs0_err_o			(wbs_i_rom0.err),
      .wbs0_rty_o			(wbs_i_rom0.rty),

      // Slave 1
      // Inputs to slave from arbiter
      .wbs1_adr_i			(wbs_i_mc0.adr),
      .wbs1_dat_i			(wbs_i_mc0.dat_wr),
      .wbs1_sel_i			(wbs_i_mc0.sel),
      .wbs1_we_i			(wbs_i_mc0.we),
      .wbs1_cyc_i			(wbs_i_mc0.cyc),
      .wbs1_stb_i			(wbs_i_mc0.stb),
      .wbs1_cti_i			(wbs_i_mc0.cti),
      .wbs1_bte_i			(wbs_i_mc0.bte),
      // Outputs from slave to arbiter
      .wbs1_dat_o			(wbs_i_mc0.dat_rd),
      .wbs1_ack_o			(wbs_i_mc0.ack),
      .wbs1_err_o			(wbs_i_mc0.err),
      .wbs1_rty_o			(wbs_i_mc0.rty),

      // Clock, reset inputs
      .wb_clk				(wb_clk),
      .wb_rst				(wb_rst));

   defparam arbiter_ibus0.wb_addr_match_width = ibus_arb_addr_match_width;

   defparam arbiter_ibus0.slave0_adr = ibus_arb_slave0_adr; // ROM
   defparam arbiter_ibus0.slave1_adr = ibus_arb_slave1_adr; // Main memory

   //
   // Wishbone data bus arbiter
   //
   
   arbiter_dbus arbiter_dbus0
     (
      // Master 0
      // Inputs to arbiter from master
      .wbm0_adr_o			(wbm_d_or12.adr),
      .wbm0_dat_o			(wbm_d_or12.dat_wr),
      .wbm0_sel_o			(wbm_d_or12.sel),
      .wbm0_we_o			(wbm_d_or12.we),
      .wbm0_cyc_o			(wbm_d_or12.cyc),
      .wbm0_stb_o			(wbm_d_or12.stb),
      .wbm0_cti_o			(wbm_d_or12.cti),
      .wbm0_bte_o			(wbm_d_or12.bte),
      // Outputs to master from arbiter
      .wbm0_dat_i			(wbm_d_or12.dat_rd),
      .wbm0_ack_i			(wbm_d_or12.ack),
      .wbm0_err_i			(wbm_d_or12.err),
      .wbm0_rty_i			(wbm_d_or12.rty),

      // Master 0
      // Inputs to arbiter from master
      .wbm1_adr_o			(wbm_d_dbg.adr),
      .wbm1_dat_o			(wbm_d_dbg.dat_wr),
      .wbm1_we_o			(wbm_d_dbg.we),
      .wbm1_cyc_o			(wbm_d_dbg.cyc),
      .wbm1_sel_o			(wbm_d_dbg.sel),
      .wbm1_stb_o			(wbm_d_dbg.stb),
      .wbm1_cti_o			(wbm_d_dbg.cti),
      .wbm1_bte_o			(wbm_d_dbg.bte),
      // Outputs to master from arbiter      
      .wbm1_dat_i			(wbm_d_dbg.dat_rd),
      .wbm1_ack_i			(wbm_d_dbg.ack),
      .wbm1_err_i			(wbm_d_dbg.err),
      .wbm1_rty_i			(wbm_d_dbg.rty),

      // Slaves
      
      .wbs0_adr_i			(wbs_d_mc0.adr),
      .wbs0_dat_i			(wbs_d_mc0.dat_wr),
      .wbs0_sel_i			(wbs_d_mc0.sel),
      .wbs0_we_i			(wbs_d_mc0.we),
      .wbs0_cyc_i			(wbs_d_mc0.cyc),
      .wbs0_stb_i			(wbs_d_mc0.stb),
      .wbs0_cti_i			(wbs_d_mc0.cti),
      .wbs0_bte_i			(wbs_d_mc0.bte),
      .wbs0_dat_o			(wbs_d_mc0.dat_rd),
      .wbs0_ack_o			(wbs_d_mc0.ack),
      .wbs0_err_o			(wbs_d_mc0.err),
      .wbs0_rty_o			(wbs_d_mc0.rty),

      .wbs1_adr_i			(wbm_b_d.adr),
      .wbs1_dat_i			(wbm_b_d.dat_wr),
      .wbs1_sel_i			(wbm_b_d.sel),
      .wbs1_we_i			(wbm_b_d.we),
      .wbs1_cyc_i			(wbm_b_d.cyc),
      .wbs1_stb_i			(wbm_b_d.stb),
      .wbs1_cti_i			(wbm_b_d.cti),
      .wbs1_bte_i			(wbm_b_d.bte),
      .wbs1_dat_o			(wbm_b_d.dat_rd),
      .wbs1_ack_o			(wbm_b_d.ack),
      .wbs1_err_o			(wbm_b_d.err),
      .wbs1_rty_o			(wbm_b_d.rty),

      // Clock, reset inputs
      .wb_clk			(wb_clk),
      .wb_rst			(wb_rst));

   // These settings are from top level params file
   defparam arbiter_dbus0.wb_addr_match_width = dbus_arb_wb_addr_match_width;
   defparam arbiter_dbus0.wb_num_slaves = dbus_arb_wb_num_slaves;
   defparam arbiter_dbus0.slave0_adr = dbus_arb_slave0_adr;
   defparam arbiter_dbus0.slave1_adr = dbus_arb_slave1_adr;

   //
   // Wishbone byte-wide bus arbiter
   //   
   
   arbiter_bytebus arbiter_bytebus0
     (

      // Master 0
      // Inputs to arbiter from master
      .wbm0_adr_o			(wbm_b_d.adr),
      .wbm0_dat_o			(wbm_b_d.dat_wr),
      .wbm0_sel_o			(wbm_b_d.sel),
      .wbm0_we_o			(wbm_b_d.we),
      .wbm0_cyc_o			(wbm_b_d.cyc),
      .wbm0_stb_o			(wbm_b_d.stb),
      .wbm0_cti_o			(wbm_b_d.cti),
      .wbm0_bte_o			(wbm_b_d.bte),
      // Outputs to master from arbiter
      .wbm0_dat_i			(wbm_b_d.dat_rd),
      .wbm0_ack_i			(wbm_b_d.ack),
      .wbm0_err_i			(wbm_b_d.err),
      .wbm0_rty_i			(wbm_b_d.rty),

      // Byte bus slaves
      
      .wbs0_adr_i			(wbs_d_uart0.adr),
      .wbs0_dat_i			(wbs_d_uart0.dat_wr),
      .wbs0_we_i			(wbs_d_uart0.we),
      .wbs0_cyc_i			(wbs_d_uart0.cyc),
      .wbs0_stb_i			(wbs_d_uart0.stb),
      .wbs0_cti_i			(wbs_d_uart0.cti),
      .wbs0_bte_i			(wbs_d_uart0.bte),
      .wbs0_dat_o			(wbs_d_uart0.dat_rd),
      .wbs0_ack_o			(wbs_d_uart0.ack),
      .wbs0_err_o			(wbs_d_uart0.err),
      .wbs0_rty_o			(wbs_d_uart0.rty),

      .wbs1_adr_i			(wbs_d_intgen.adr),
      .wbs1_dat_i			(wbs_d_intgen.dat_wr),
      .wbs1_we_i			(wbs_d_intgen.we),
      .wbs1_cyc_i			(wbs_d_intgen.cyc),
      .wbs1_stb_i			(wbs_d_intgen.stb),
      .wbs1_cti_i			(wbs_d_intgen.cti),
      .wbs1_bte_i			(wbs_d_intgen.bte),
      .wbs1_dat_o			(wbs_d_intgen.dat_rd),
      .wbs1_ack_o			(wbs_d_intgen.ack),
      .wbs1_err_o			(wbs_d_intgen.err),
      .wbs1_rty_o			(wbs_d_intgen.rty),

      // Clock, reset inputs
      .wb_clk			(wb_clk),
      .wb_rst			(wb_rst));

   defparam arbiter_bytebus0.wb_addr_match_width = bbus_arb_wb_addr_match_width;
   defparam arbiter_bytebus0.wb_num_slaves = bbus_arb_wb_num_slaves;

   defparam arbiter_bytebus0.slave0_adr = bbus_arb_slave0_adr;
   defparam arbiter_bytebus0.slave1_adr = bbus_arb_slave1_adr;


   ////////////////////////////////////////////////////////////////////////
   //
   // OpenRISC processor
   // 
   ////////////////////////////////////////////////////////////////////////

   // 
   // Wires
   // 
   
   wire [19:0] 				  or1200_pic_ints;

   wire [31:0] 				  or1200_dbg_dat_i;
   wire [31:0] 				  or1200_dbg_adr_i;
   wire 				  or1200_dbg_we_i;
   wire 				  or1200_dbg_stb_i;
   wire 				  or1200_dbg_ack_o;
   wire [31:0] 				  or1200_dbg_dat_o;
   
   wire 				  or1200_dbg_stall_i;
   wire 				  or1200_dbg_ewt_i;
   wire [3:0] 				  or1200_dbg_lss_o;
   wire [1:0] 				  or1200_dbg_is_o;
   wire [10:0] 				  or1200_dbg_wp_o;
   wire 				  or1200_dbg_bp_o;
   wire 				  or1200_dbg_rst;   
   
   wire 				  or1200_clk, or1200_rst;
   wire 				  sig_tick;
   
   //
   // Assigns
   //
   assign or1200_clk = wb_clk;
   assign or1200_rst = wb_rst | or1200_dbg_rst;

   // 
   // Instantiation
   //    
   or1200_top or1200_top0
       (
	// Instruction bus, clocks, reset
	.iwb_clk_i			(wb_clk),
	.iwb_rst_i			(wb_rst),
	.iwb_ack_i			(wbm_i_or12.ack),
	.iwb_err_i			(wbm_i_or12.err),
	.iwb_rty_i			(wbm_i_or12.rty),
	.iwb_dat_i			(wbm_i_or12.dat_rd),
	
	.iwb_cyc_o			(wbm_i_or12.cyc),
	.iwb_adr_o			(wbm_i_or12.adr),
	.iwb_stb_o			(wbm_i_or12.stb),
	.iwb_we_o			(wbm_i_or12.we),
	.iwb_sel_o			(wbm_i_or12.sel),
	.iwb_dat_o			(wbm_i_or12.dat_wr),
	.iwb_cti_o			(wbm_i_or12.cti),
	.iwb_bte_o			(wbm_i_or12.bte),
	
	// Data bus, clocks, reset            
	.dwb_clk_i			(wb_clk),
	.dwb_rst_i			(wb_rst),
	.dwb_ack_i			(wbm_d_or12.ack),
	.dwb_err_i			(wbm_d_or12.err),
	.dwb_rty_i			(wbm_d_or12.rty),
	.dwb_dat_i			(wbm_d_or12.dat_rd),

	.dwb_cyc_o			(wbm_d_or12.cyc),
	.dwb_adr_o			(wbm_d_or12.adr),
	.dwb_stb_o			(wbm_d_or12.stb),
	.dwb_we_o			(wbm_d_or12.we),
	.dwb_sel_o			(wbm_d_or12.sel),
	.dwb_dat_o			(wbm_d_or12.dat_wr),
	.dwb_cti_o			(wbm_d_or12.cti),
	.dwb_bte_o			(wbm_d_or12.bte),
	
	// Debug interface ports
	.dbg_stall_i			(or1200_dbg_stall_i),
	//.dbg_ewt_i			(or1200_dbg_ewt_i),
	.dbg_ewt_i			(1'b0),
	.dbg_lss_o			(or1200_dbg_lss_o),
	.dbg_is_o			(or1200_dbg_is_o),
	.dbg_wp_o			(or1200_dbg_wp_o),
	.dbg_bp_o			(or1200_dbg_bp_o),

	.dbg_adr_i			(or1200_dbg.adr),      
	.dbg_we_i			(or1200_dbg.we ), 
	.dbg_stb_i			(or1200_dbg.stb),          
	.dbg_dat_i			(or1200_dbg.dat_wr),
	.dbg_dat_o			(or1200_dbg.dat_rd),
	.dbg_ack_o			(or1200_dbg.ack),
	
	.pm_clksd_o			(),
	.pm_dc_gate_o			(),
	.pm_ic_gate_o			(),
	.pm_dmmu_gate_o			(),
	.pm_immu_gate_o			(),
	.pm_tt_gate_o			(),
	.pm_cpu_gate_o			(),
	.pm_wakeup_o			(),
	.pm_lvolt_o			(),

	// Core clocks, resets
	.clk_i				(or1200_clk),
	.rst_i				(or1200_rst),
	
	.clmode_i			(2'b00),
	// Interrupts      
	.pic_ints_i			(or1200_pic_ints),
	.sig_tick(sig_tick),
	/*
	 .mbist_so_o			(),
	 .mbist_si_i			(0),
	 .mbist_ctrl_i			(0),
	 */

	.pm_cpustall_i			(1'b0)

	);
   
   ////////////////////////////////////////////////////////////////////////



   assign wbm_d_dbg_adr_o = 0;   
   assign wbm_d_dbg_dat_o = 0;   
   assign wbm_d_dbg_cyc_o = 0;   
   assign wbm_d_dbg_stb_o = 0;   
   assign wbm_d_dbg_sel_o = 0;   
   assign wbm_d_dbg_we_o  = 0;   
   assign wbm_d_dbg_cti_o = 0;   
   assign wbm_d_dbg_bte_o = 0;
   
   ahb2wb ahb2wb(
		 .adr_o(or1200_dbg.adr), .dat_o (or1200_dbg.dat_wr), 
		 .dat_i(or1200_dbg.dat_rd), .ack_i(or1200_dbg.ack), .cyc_o(),
		 .we_o(or1200_dbg.we), .stb_o(or1200_dbg.stb), 
		 .clk_i(wb_clk), .hclk(wb_clk), .rst_i(wb_rst),.hresetn(!wb_rst), .*
		 );
		 
   
   ////////////////////////////////////////////////////////////////////////   
   

   ////////////////////////////////////////////////////////////////////////
   //
   // ROM
   // 
   ////////////////////////////////////////////////////////////////////////
`ifdef BOOTROM   
   rom rom0
     (
      .wb_dat_o				(wbs_i_rom0.dat_rd),
      .wb_ack_o				(wbs_i_rom0.ack),
      .wb_adr_i				(wbs_i_rom0.adr[(wbs_i_rom0_addr_width+2)-1:2]),
      .wb_stb_i				(wbs_i_rom0.stb),
      .wb_cyc_i				(wbs_i_rom0.cyc),
      .wb_cti_i				(wbs_i_rom0.cti),
      .wb_bte_i				(wbs_i_rom0.bte),
      .wb_clk				(wb_clk),
      .wb_rst				(wb_rst));

   defparam rom0.addr_width = wbs_i_rom0_addr_width;
`else // !`ifdef BOOTROM
   assign wbs_i_rom0.dat_rd = 0;
   assign wbs_i_rom0.ack = 0;
`endif // !`ifdef BOOTROM

   assign wbs_i_rom0.err = 0;
   assign wbs_i_rom0.rty = 0;
   
   ////////////////////////////////////////////////////////////////////////

`ifdef RAM_WB
   ////////////////////////////////////////////////////////////////////////
   //
   // Generic main RAM
   // 
   ////////////////////////////////////////////////////////////////////////


   ram_wb ram_wb0
     (
      // Wishbone slave interface 0
      .wbm0_dat_i			(wbs_i_mc0.dat_wr),
      .wbm0_adr_i			(wbs_i_mc0.adr),
      .wbm0_sel_i			(wbs_i_mc0.sel),
      .wbm0_cti_i			(wbs_i_mc0.cti),
      .wbm0_bte_i			(wbs_i_mc0.bte),
      .wbm0_we_i			(wbs_i_mc0.we ),
      .wbm0_cyc_i			(wbs_i_mc0.cyc),
      .wbm0_stb_i			(wbs_i_mc0.stb),
      .wbm0_dat_o			(wbs_i_mc0.dat_rd),
      .wbm0_ack_o			(wbs_i_mc0.ack),
      .wbm0_err_o                       (wbs_i_mc0.err),
      .wbm0_rty_o                       (wbs_i_mc0.rty),
      // Wishbone slave interface 1
      .wbm1_dat_i			(wbs_d_mc0.dat_wr),
      .wbm1_adr_i			(wbs_d_mc0.adr),
      .wbm1_sel_i			(wbs_d_mc0.sel),
      .wbm1_cti_i			(wbs_d_mc0.cti),
      .wbm1_bte_i			(wbs_d_mc0.bte),
      .wbm1_we_i			(wbs_d_mc0.we ),
      .wbm1_cyc_i			(wbs_d_mc0.cyc),
      .wbm1_stb_i			(wbs_d_mc0.stb),
      .wbm1_dat_o			(wbs_d_mc0.dat_rd),
      .wbm1_ack_o			(wbs_d_mc0.ack),
      .wbm1_err_o                       (wbs_d_mc0.err),
      .wbm1_rty_o                       (wbs_d_mc0.rty),
      // Wishbone slave interface 2
      .wbm2_dat_i			(32'd0),
      .wbm2_adr_i			(32'd0),
      .wbm2_sel_i			(4'd0),
      .wbm2_cti_i			(3'd0),
      .wbm2_bte_i			(2'd0),
      .wbm2_we_i			(1'd0),
      .wbm2_cyc_i			(1'd0),
      .wbm2_stb_i			(1'd0),
      .wbm2_dat_o			(),
      .wbm2_ack_o			(),
      .wbm2_err_o                       (),
      .wbm2_rty_o                       (),
      // Clock, reset
      .wb_clk_i				(wb_clk),
      .wb_rst_i				(wb_rst));

   defparam ram_wb0.aw = wb_aw;
   defparam ram_wb0.dw = wb_dw;

   defparam ram_wb0.mem_size_bytes = (8192*1024); // 8MB
   defparam ram_wb0.mem_adr_width = 16; // log2(8192*1024)
   
   
   ////////////////////////////////////////////////////////////////////////
`endif   
`ifdef UART0
   ////////////////////////////////////////////////////////////////////////
   //
   // UART0
   // 
   ////////////////////////////////////////////////////////////////////////

   //
   // Wires
   //
   wire        uart0_irq;

   //
   // Assigns
   //
   assign wbs_d_uart0_err_o = 0;
   assign wbs_d_uart0_rty_o = 0;
   
   uart16550 uart16550_0
     (
      // Wishbone slave interface
      .wb_clk_i				(wb_clk),
      .wb_rst_i				(wb_rst),
      .wb_adr_i				(wbs_d_uart0.adr[uart0_addr_width-1:0]),
      .wb_dat_i				(wbs_d_uart0.dat_wr),
      .wb_we_i				(wbs_d_uart0.we),
      .wb_stb_i				(wbs_d_uart0.stb),
      .wb_cyc_i				(wbs_d_uart0.cyc),
      //.wb_sel_i				(),
      .wb_dat_o				(wbs_d_uart0.dat_rd),
      .wb_ack_o				(wbs_d_uart0.ack),

      .int_o				(uart0_irq),
      .stx_pad_o			(uart0_stx_pad_o),
      .rts_pad_o			(),
      .dtr_pad_o			(),
      //      .baud_o				(),
      // Inputs
      .srx_pad_i			(uart0_srx_pad_i),
      .cts_pad_i			(1'b0),
      .dsr_pad_i			(1'b0),
      .ri_pad_i				(1'b0),
      .dcd_pad_i			(1'b0));

   ////////////////////////////////////////////////////////////////////////          
`else // !`ifdef UART0
   
   //
   // Assigns
   //
   assign wbs_d_uart0_err_o = 0;   
   assign wbs_d_uart0_rty_o = 0;
   assign wbs_d_uart0_ack_o = 0;
   assign wbs_d_uart0_dat_o = 0;
   
   ////////////////////////////////////////////////////////////////////////       
`endif // !`ifdef UART0

`ifdef INTGEN

   wire        intgen_irq;

   intgen intgen0
     (
      .clk_i                           (wb_clk),
      .rst_i                           (wb_rst),
      .wb_adr_i                        (wbs_d_intgen.adr[intgen_addr_width-1:0]),
      .wb_cyc_i                        (wbs_d_intgen.cyc),
      .wb_stb_i                        (wbs_d_intgen.stb),
      .wb_dat_i                        (wbs_d_intgen.dat_wr),
      .wb_we_i                         (wbs_d_intgen.we),
      .wb_ack_o                        (wbs_d_intgen.ack),
      .wb_dat_o                        (wbs_d_intgen.dat_rd),
      
      .irq_o                           (intgen_irq)
      );

`endif //  `ifdef INTGEN
   assign wbs_d_intgen_err_o = 0;
   assign wbs_d_intgen_rty_o = 0;
   
   
   ////////////////////////////////////////////////////////////////////////
   //
   // OR1200 Interrupt assignment
   // 
   ////////////////////////////////////////////////////////////////////////
   
   assign or1200_pic_ints[0] = 0; // Non-maskable inside OR1200
   assign or1200_pic_ints[1] = 0; // Non-maskable inside OR1200
`ifdef UART0
   assign or1200_pic_ints[2] = uart0_irq;
`else   
   assign or1200_pic_ints[2] = 0;
`endif
   assign or1200_pic_ints[3] = 0;
   assign or1200_pic_ints[4] = 0;
   assign or1200_pic_ints[5] = 0;
`ifdef SPI0
   assign or1200_pic_ints[6] = spi0_irq;
`else   
   assign or1200_pic_ints[6] = 0;
`endif
   assign or1200_pic_ints[7] = 0;
   assign or1200_pic_ints[8] = 0;
   assign or1200_pic_ints[9] = 0;
   assign or1200_pic_ints[10] = 0;
   assign or1200_pic_ints[11] = 0;
   assign or1200_pic_ints[12] = 0;
   assign or1200_pic_ints[13] = 0;
   assign or1200_pic_ints[14] = 0;
   assign or1200_pic_ints[15] = 0;
   assign or1200_pic_ints[16] = 0;
   assign or1200_pic_ints[17] = 0;
   assign or1200_pic_ints[18] = 0;
`ifdef INTGEN
   assign or1200_pic_ints[19] = intgen_irq;
`else
   assign or1200_pic_ints[19] = 0;
`endif
   
endmodule // top

// Local Variables:
// verilog-library-directories:("." "../arbiter" "../uart16550" "../or1200" "../dbg_if" "../jtag_tap" "../rom" "../simple_spi" )
// verilog-library-files:()
// verilog-library-extensions:(".v" ".h")
// End:

