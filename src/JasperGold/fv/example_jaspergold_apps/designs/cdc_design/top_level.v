// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module top_level (
    // CAR Signals
    input       clock_control1,
    input       clock_control2,
    input       clock_control_sel,
    input       clock_fsm,
    input       clock_fsm_aux,
    input       reset_n_control1,
    input       reset_n_control2,
    input       reset_n_fsm,
    input       en_control,
    input       en_fsm,
    input       [15:0] reg_addr,
    input       [31:0] reg_wdata,
    input              reg_mode,

    //Control signals
    input       [7:0] control_data,
    input       [7:0] data_in,
    input       [7:0] hshake_data_in,
    input       load_data,
    input       write_on_fifo,
    input       control_sig,
    input       change_fsm_state,
    input       counter_en,
    input       conv_br1,
    input       conv_br2,

    //FSM Signals
    output      [31:0] output_data,
    output      [7:0]  hshake_out_data,
    output      output_valid,
    output      buffer_lsw_out,
    output      [7:0] buffer_lsw_ctrl_vec,
    input       [2:0] proc_int_code,
    input       proc_int_control,
    input       in_reg1,

    //Output ports
    output      [7:0] control_data_shift,
    output      [7:0] counter_check,
    output      [31:0] inv_data_out,
    output      conv_out,
    output reg  sync_chain_out
);

wire clk_control,rst_n_control;
wire clk_fsm,rst_n_fsm;
wire clock_control, clk_div;

wire [31:0] output_data_inv;
wire [31:0] write_data_on_fifo1;
wire [7:0] write_data_on_fifo2;
wire [7:0]  buffer_lsw;
wire write_en;
wire fifo_full1;
wire fifo_full2;
wire control_counter;
wire [7:0] count_out_control;
wire [7:0] count_out_fsm;
wire control_state;
wire error_sig;
wire [31:0] reg_rdata;
wire inv_data_en;

wire [31:0] read_from_fifo;
wire read_en;
wire fifo_empty1;
wire fifo_empty2;
wire inp1,inp2, in_reg1_sel;
wire in_reg2_comb_out;

reg bla, dst;
reg sync_out_reg, sync_out;
reg sync_out_reg2, sync_out2;
reg conv_br1_reg, conv_br2_reg, conv_out1_reg, conv_out2_reg, conv_out1, conv_out2;
reg [7:0] buffer_lsw_reg, buffer_lsw_sync;
wire [2:0] i_code;
wire i_valid;
wire hshake_req, rcv_ready;
wire rst_n_control_sync;
wire rst_n_control_fsm;

//Clock Mux
assign clock_control = clock_control_sel ? clock_control1 : clock_control2;

//CAR block
car clocks_and_resets (
    .clk1               (clock_control),
    .clk2               (clock_fsm),
    .rst_n1             (reset_n_control1),
    .rst_n2             (reset_n_fsm),
    .en1                (en_control),
    .en2                (en_fsm),
    .clk1_g             (clk_control),
    .clk2_g             (clk_fsm),
    .rst_n_reg1         (rst_n_control),
    .rst_n_reg2         (rst_n_fsm),
    .clk1_div           (clk_div)
);

//Control block
control control_block (
    .clk                (clk_control),
    .clk_div            (clk_div),
    .rst1_n             (rst_n_control),
    .rst2_n             (reset_n_control2),
    .data_in            (data_in),
    .inv_data_in        (output_data_inv),
    .inv_data_en_pulse  (inv_data_en_pulse),
    .inv_data_out       (inv_data_out),
    .load_data          (load_data),
    .write_on_fifo      (write_on_fifo),
    .control_sig        (control_sig),
    .change_fsm_state   (change_fsm_state),
    .en_fsm             (en_fsm),
    .counter_en         (counter_en),
    .data_fifo1         (write_data_on_fifo1),
    .data_fifo2         (write_data_on_fifo2),
    .buffer_lsw         (buffer_lsw),
    .write_en           (write_en),
    .fifo1_full         (fifo_full1),
    .fifo2_full         (fifo_full2),
    .control_counter    (control_counter),
    .count_out_control  (count_out_control),
    .control_state      (control_state),
    .error_sig          (error_sig),
    .interruption_code  (i_code),
    .interruption_valid (i_valid)
);

//FSM block
fsm FSM_block (
    .clk                (clk_fsm),
    .rst1_n             (rst_n_fsm),
    .rst2_n             (rst_n_control),
    .data_fifo1         (read_from_fifo1),
    .data_fifo2         (read_from_fifo2),
    .read_en            (read_en),
    .fifo1_empty         (fifo_empty1),
    .fifo2_empty         (fifo_empty2),
    .control_counter    (control_counter),
    .control_state      (control_state),
    .error_sig          (error_sig),
    .counter_en         (counter_en),
    .buffer_lsw         (buffer_lsw),
    .reg_rdata_i        (reg_rdata),
    .buffer_lsw_out     (buffer_lsw_out),
    .data_out1           (output_data),
    .data_out2           (),
    .data_out_inv       (output_data_inv),
    .inv_data_en_out    (inv_data_en),
    .valid_data         (output_valid),
    .count_out_fsm      (count_out_fsm),
    .interruption_code  (proc_int_code),
    .interruption       (proc_int_control),
    .i_code             (i_code),
    .i_valid            (i_valid)
);

//FIFO1
afifo #(.D_WIDTH (32)) fifo_sync1  (
    .wr_clk             (clk_control),
    .rd_clk             (clk_fsm),
    .wr_rst_n           (rst_n_control_sync),
    .rd_rst_n           (rst_n_fsm_sync),
    .i_data             (write_data_on_fifo1),
    .o_data             (read_from_fifo1),
    .i_push             (write_en),
    .i_pop              (read_en),
    .o_full             (fifo_full1),
    .o_empty            (fifo_empty1)
);

//FIFO2
afifo #(.D_WIDTH (8)) fifo_sync2  (
    .wr_clk             (clk_control),
    .rd_clk             (clk_fsm),
    .wr_rst_n           (rst_n_control_sync),
    .rd_rst_n           (rst_n_fsm_sync),
    .i_data             (write_data_on_fifo2),
    .o_data             (read_from_fifo2),
    .i_push             (write_en),
    .i_pop              (read_en),
    .o_full             (fifo_full2),
    .o_empty            (fifo_empty2)
);

//FIFO3
fifo1 #(.DSIZE (8), .ASIZE (4)) ctrl2fsm_fifo_sync (
    .wclk(clk_control),
    .rclk(clk_fsm),
    .wrst_n(rst_n_control_sync),
    .rrst_n(rst_n_fsm_sync),
    .wdata(write_data_on_fifo2),
    .rdata(),
    .winc(write_en),
    .rinc(read_en),
    .wfull(fifo_full),
    .rempty(fifo_empty)
);

rst_sync rst_sync_control (clk_control, rst_n_control, rst_n_control_sync);
rst_sync rst_sync_fsm     (clk_fsm, rst_n_fsm, rst_n_fsm_sync);

//Handshake
hsync hsync_inst (
    .srst(rst_n_control_sync),
    .drst(rst_n_fsm_sync),
    .sclk(clk_control),
    .dclk(clk_fsm),
    .start(hshake_req),
    .ready(rcv_ready),
    .din(hshake_data_in),
    .dout(hshake_out_data)
);

assign counter_check = count_out_fsm ^ count_out_control;

//Auto-waiver
always @(posedge clk_control)
begin
    conv_br1_reg <= conv_br1;
    conv_br2_reg <= conv_br2;
end

always @(posedge clk_fsm)
begin
    conv_out1_reg <= conv_br1_reg;
    conv_out2_reg <= conv_br2_reg;
    conv_out1 <= conv_out1_reg;
    conv_out2 <= conv_out2_reg;
end

assign conv_out = conv_out1 && conv_out2;

assign in_reg1_comb_out = in_reg1_sel ? in_reg1 : 1'b0;

always @(posedge clk_fsm)
begin
    dst <= in_reg1_comb_out;
    sync_chain_out <= dst && inp1;
end

always @(posedge clk_fsm)
begin
    sync_out_reg <= in_reg1_comb_out;
    sync_out <= sync_out_reg;
end

assign in_reg2_comb_out = count_out_fsm & count_out_control; 
always @(posedge clk_fsm)
begin
    sync_out_reg2 <= in_reg2_comb_out;
    sync_out2     <= inp2 ? sync_out_reg2 : 1'b0;
end

//NDFF Bus 
always @(posedge clk_fsm or negedge rst_n_fsm)
begin
    if (rst_n_fsm == 1'b0) begin
        buffer_lsw_reg <= 8'b0;
        buffer_lsw_sync <= 8'b0;
    end else begin
        buffer_lsw_reg <= buffer_lsw;
        buffer_lsw_sync <= buffer_lsw_reg;
    end
end

assign buffer_lsw_ctrl_vec = buffer_lsw_sync;

//Remove scheme
siso reg_shft (.clk(clk_fsm), .din(change_fsm_state), .dout(change_fsm_state_shift));

siso shift0 (.clk(clk_fsm), .din(control_data[0]), .dout(control_data_shift[0]));
siso shift1 (.clk(clk_fsm), .din(control_data[1]), .dout(control_data_shift[1]));
siso shift2 (.clk(clk_fsm), .din(control_data[2]), .dout(control_data_shift[2]));
siso shift3 (.clk(clk_fsm), .din(control_data[3]), .dout(control_data_shift[3]));
siso shift4 (.clk(clk_fsm), .din(control_data[4]), .dout(control_data_shift[4]));
siso shift5 (.clk(clk_fsm), .din(control_data[5]), .dout(control_data_shift[5]));
siso shift6 (.clk(clk_fsm), .din(control_data[6]), .dout(control_data_shift[6]));
siso shift7 (.clk(clk_fsm), .din(control_data[7]), .dout(control_data_shift[7]));


//Mux pulse sync
pulse pulse_sync(.clk1(clk_fsm), 
                 .clk2(clk_control), 
                 .rst1(rst_n_fsm_sync), 
                 .rst2(rst_n_control_sync), 
                 .pulse_in(inv_data_en), 
                 .pulse_out(inv_data_en_pulse)
                );

//BBox output handling
modreg_bank u_regbank(.prst_n_i(reset_n_control2),
                      .pclk_i(clk_control),
                      .penable_i(en_control),
                      .paddr_i(reg_addr),
                      .pwrite_i(load_data),
                      .pwdata_i(reg_wdata),
                      .pmodsel_i(reg_mode),
                      .prdata_o(reg_rdata)
                     );
//Embedded properties
property counters_equal_2_cycles_apart;
@(posedge top_level.clock_fsm) disable iff (!top_level.reset_n_fsm)
    top_level.counter_en |-> ##2 top_level.control_block.count_out_control == $past(top_level.FSM_block.count_out_fsm, 2);
endproperty

//property counter_counts;
//@(posedge clock_control1) disable iff (!reset_n_fsm)
//counter_en |=> ##2 control_block.count_out_control == ($past(control_block.count_out_control)+1'b1);
//endproperty
//
//property counter_doesnt_count;
//@(posedge clock_control1) disable iff (!reset_n_fsm)
//!counter_en |=> ##2 control_block.count_out_control == $past(control_block.count_out_control);
//endproperty
//
//assert property(counter_counts);
//assert property(counter_doesnt_count);
assert property (counters_equal_2_cycles_apart);
endmodule
