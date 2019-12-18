// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module control (
    //Clocks and resets
    input       clk,
    input       clk_div,
    input       rst1_n,
    input       rst2_n,

    //Data and control Sigs
    input       [7:0] data_in,
    input       [31:0] inv_data_in,
    input       inv_data_en_pulse,
    input       load_data,
    input       write_on_fifo,
    input       control_sig,
    input       change_fsm_state,
    input       en_fsm,
    input       counter_en,

    //FIFO interface
    output      [31:0] data_fifo1,
    output      [7:0] data_fifo2,
    output      [7:0] buffer_lsw,
    output      write_en,
    input       fifo1_full,
    input       fifo2_full,

    //FSM write interface
    output      control_counter,
    output reg  [31:0] inv_data_out,
    output      [7:0] count_out_control,
    output      control_state,
    output reg  error_sig,
    input       [2:0] interruption_code,
    input       interruption_valid
);

reg control_counter_r;
reg [31:0] buffer_data;
reg [1:0] buffer_a;
reg write_en_reg;
reg error_sig_r;
reg control_state_r;
reg counter_en_reg1;
reg counter_en_sync;

wire rst1_n_sync;

assign control_state = control_state_r & en_fsm;
assign control_counter = control_counter_r;
assign write_en = write_en_reg;
assign data_fifo1 = buffer_data;
assign data_fifo2 = buffer_data[15:8];
assign buffer_lsw = buffer_data[7:0];


//Reset Synchronizer
rst_sync control_rst1_n_sync (clk, rst1_n, rst1_n_sync);

//Control the counter
always @ (posedge clk,negedge rst1_n_sync)
    if (~rst1_n_sync)
        control_counter_r <= 1'b0;
    else
        control_counter_r <= control_sig;

//FSM control
always @ (posedge clk,negedge rst1_n_sync)
    if (~rst1_n_sync)
        control_state_r <= 1'b0;
    else
        control_state_r <= change_fsm_state;

//Buffer the data before sending it to the FIFO
//buffer_a is a counter
always @ (posedge clk, negedge rst1_n_sync)
    if (~rst1_n_sync)
        buffer_a <= 2'd0;
    else
        buffer_a <= buffer_a + 1'b1;

always @ (posedge clk, negedge rst1_n_sync)
    if (~rst1_n_sync)
        buffer_data <= 32'd0;
    else begin
        if (load_data)
            case (buffer_a)
                2'b00: buffer_data[7:0] <= data_in;
                2'b01: buffer_data[15:8] <= data_in;
                2'b10: buffer_data[23:16] <= data_in;
                2'b11: buffer_data[31:24] <= data_in;
            endcase
    end

//FIFO control_counter
always @ (posedge clk, negedge rst1_n_sync)
    if (~rst1_n_sync)
        write_en_reg <= 1'b0;
    else
        write_en_reg <= write_on_fifo & !fifo1_full;

//Error signal is created when the a write_on_fifo signal is asserted with the full signal also asserted
//This has a protocol data_stability issue, because the write on fifo signal can be asserted only for one cycle.
always @ (posedge clk, negedge rst1_n_sync)
    if (~rst1_n_sync)
        error_sig_r <= 1'b0;
    else
        error_sig_r <= write_on_fifo & fifo1_full;

//Reset Synchronization issue within same clock domain
always @(posedge clk, negedge rst2_n)
    if (~rst2_n)
        error_sig <= 1'b0;
    else
        error_sig <= error_sig_r;

//Interruption manager
interruption_manager i_manager (
    .clk        (clk_div),
    .rst_n      (rst1_n_sync),
    .i_code     (interruption_code),
    .i_valid    (interruption_valid),
    .stop1      (stop_sig1),
    .stop2      (stop_sig2),
    .stop3      (stop_sig3)
);

//Mux pulse sync

always @(posedge clk or negedge rst1_n_sync)
begin
    if (~rst1_n_sync) begin
        inv_data_out <= 32'b0;
    end else begin
        inv_data_out <= inv_data_en_pulse ? inv_data_in : inv_data_out;
    end
end

//Demo metastability debug
always @(posedge clk or negedge rst1_n_sync)
begin
    if (~rst1_n_sync) begin
        counter_en_reg1 <= 1'b0;
        counter_en_sync <= 1'b0;
    end else begin
        counter_en_reg1 <= counter_en;
        counter_en_sync <= counter_en_reg1;
    end
end
counter control_blk_counter(clk, rst1_n_sync, counter_en_sync, count_out_control); 
endmodule
