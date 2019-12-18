// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module fsm (
    input       clk,
    input       rst1_n,
    input       rst2_n,

    //FIFO read interface
    input       [31:0] data_fifo1,
    input       [7:0] data_fifo2,
    output      read_en,
    input       fifo1_empty,
    input       fifo2_empty,

    //Control interface
    input       control_counter,
    input       control_state,
    input       error_sig,
    input       counter_en,
    
    //Data interface
    input       [7:0] buffer_lsw,
    input       [31:0] reg_rdata_i,
    output reg  buffer_lsw_out,

    //
    output      [31:0] data_out1,
    output      [7:0] data_out2,
    output      [31:0] data_out_inv,
    output reg  inv_data_en_out,
    output      valid_data,
    output      [7:0] count_out_fsm,
    input       [2:0] interruption_code,
    input       interruption,
    output reg  [2:0] i_code,
    output reg  i_valid
);

//States
parameter   start = 3'd0,
            waiting = 3'd1,
            reading = 3'd2,
            data_load = 3'd3,
            error_state = 3'd4,
            int_state1 = 3'd5,
            int_state2 = 3'd6,
            int_state3 = 3'd7;


//Synchronizing the control signals
wire control_counter_syn;
wire control_state_syn;
wire error_syn;
wire buffer_lsw_conv;
wire sync_rst_n;
wire rst1_n_sync;

//Data registers
reg [7:0] buffer_lsw_in_reg;
reg [7:0] buffer_lsw_reg_d;
reg [7:0] buffer_lsw_reg;
reg [31:0] data_out_r1;
reg [7:0] data_out_r2;
reg [2:0] i_code_reg;
//reg       buffer_lsw_out;

//Reset Synchronization
rst_sync rst_sync2 (clk, rst1_n, rst1_n_sync);
rst_sync rst_sync1 (clk, rst2_n, sync_rst_n);
ndff_sync counter_sync (clk,sync_rst_n,control_counter,control_counter_syn);
ndff_sync state_sync (clk,rst2_n,control_state,control_state_syn);
ndff_sync error_sync (clk,sync_rst_n,error_sig,error_syn);

//Pulse generators
reg control_counter_reg;
wire control_counter_pulse;

always @ (posedge clk, negedge rst1_n_sync)
    if (~rst1_n_sync)
        control_counter_reg <= 1'b0;
    else
        control_counter_reg <= control_counter_syn;

assign control_counter_pulse = control_counter_syn & !control_counter_reg;

reg control_state_reg;
wire control_state_pulse;

always @ (posedge clk, negedge rst1_n_sync)
    if (~rst1_n_sync)
        control_state_reg <= 1'b0;
    else
        control_state_reg <= control_state_syn;

assign control_state_pulse = control_state_syn & !control_state_reg;

always @(posedge clk, negedge rst1_n_sync)
begin
    if (~rst1_n_sync)
        buffer_lsw_in_reg <= 8'b0;
    else
        buffer_lsw_in_reg <= buffer_lsw;
end

//Reconvergence
ndff_sync buf_lsw_sync0 (clk, rst1_n_sync, buffer_lsw_in_reg[0], buffer_lsw_reg[0]);
ndff_sync buf_lsw_sync1 (clk, rst1_n_sync, buffer_lsw_in_reg[1], buffer_lsw_reg[1]);
ndff_sync buf_lsw_sync2 (clk, rst1_n_sync, buffer_lsw_in_reg[2], buffer_lsw_reg[2]);
ndff_sync buf_lsw_sync3 (clk, rst1_n_sync, buffer_lsw_in_reg[3], buffer_lsw_reg[3]);
ndff_sync buf_lsw_sync4 (clk, rst1_n_sync, buffer_lsw_in_reg[4], buffer_lsw_reg[4]);
ndff_sync buf_lsw_sync5 (clk, rst1_n_sync, buffer_lsw_in_reg[5], buffer_lsw_reg[5]);
ndff_sync buf_lsw_sync6 (clk, rst1_n_sync, buffer_lsw_in_reg[6], buffer_lsw_reg[6]);
ndff_sync buf_lsw_sync7 (clk, rst1_n_sync, buffer_lsw_in_reg[7], buffer_lsw_reg[7]);

assign buffer_lsw_conv = |buffer_lsw_reg;

always @(posedge clk or negedge rst1_n_sync)
    if (~rst1_n_sync)
        buffer_lsw_out <= 1'b0;
    else
        buffer_lsw_out <= buffer_lsw_conv;

//Counter control
reg [2:0] counter;

always @ (posedge clk, negedge rst1_n_sync)
    if (~rst1_n_sync)
        counter <= 3'd0;
    else if (control_counter_pulse)
        counter <= counter + 1'b1;

//FSM logic
reg [2:0] state;
reg [2:0] next_state;

always @ (posedge clk, negedge rst1_n_sync)
    if (~rst1_n_sync)
        state <= start;
    else
        state <= next_state;

//Transition logic
always @ (*) begin
    next_state = state;
    if (interruption)
        next_state = int_state1;
    else if (control_state_pulse)
        if (error_syn)
            next_state = error_state;
        else begin
            case (state)
                start: next_state = waiting;
                waiting: if (counter == 3'd7) next_state = reading;
                reading: if (!fifo1_empty) next_state = data_load;
                data_load: next_state = start;
                int_state1: next_state = int_state2;
                int_state2: next_state = int_state3;
            endcase
        end
end

//Output Logic
reg read_en_reg;
assign read_en = read_en_reg;

always @ (posedge clk, negedge rst1_n)
    if (~rst1_n) begin
        read_en_reg <= 1'b0;
        i_code_reg <= 3'd0;
        i_valid <= 1'b0;
    end
    else begin
        case (state)
            int_state1: begin i_code_reg <= interruption_code ; i_valid <= 1'b1; end
            int_state3: i_valid <= 1'b0;
        endcase
    end

always @(posedge clk or negedge sync_rst_n)
begin
    if (~sync_rst_n)
        i_code <= 2'b0;
    else
        i_code <= i_code_reg;
end

//data_out driven based on register data
always @(posedge clk or negedge rst1_n_sync)
begin
    if (~rst1_n_sync)
        data_out_r1 <= 32'h0000;
    else if (reg_rdata_i == 32'h0000)
        data_out_r1 <= 32'hFFFF;
    else if (reg_rdata_i == 32'h1111)
        data_out_r1 <= 32'h55AA;
    else
        data_out_r1 <= data_fifo1;
end
assign data_out1 = data_out_r1;

//data_out driven based on register data
always @(posedge clk or negedge rst1_n_sync)
begin
    if (~rst1_n_sync)
        data_out_r2 <= 8'h00;
    else if (reg_rdata_i == 8'h00)
        data_out_r2 <= 8'hFF;
    else if (reg_rdata_i == 8'h11)
        data_out_r2 <= 8'h5A;
    else
        data_out_r2 <= data_fifo2;
end
assign data_out2 = data_out_r2;

assign data_out_inv = ~data_out1;

//always @(posedge clk or negedge rst1_n_sync)
//begin
//    inv_data_en_out = ~inv_data_en_out;
//end

//Demo metastability debug
counter fsm_counter(clk, rst1_n_sync, counter_en, count_out_fsm);
endmodule
