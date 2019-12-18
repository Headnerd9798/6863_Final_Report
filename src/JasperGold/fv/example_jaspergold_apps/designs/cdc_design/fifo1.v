// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module fifo1 #(parameter DSIZE = 8, parameter ASIZE = 4)
    ( output [DSIZE-1:0] rdata,
      output wfull,
      output rempty,
      input [DSIZE-1:0] wdata,
      input winc, wclk, wrst_n,
      input rinc, rclk, rrst_n
    );

    wire [ASIZE-1:0] waddr, raddr;
    wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

    //Synchronize read and write pointers
    sync_2ff sync_r2w (.ptr_sync(wq2_rptr), .ptr(rptr), .clk(wclk), .rst_n(wrst_n));
    sync_2ff sync_w2r (.ptr_sync(rq2_wptr), .ptr(wptr), .clk(rclk), .rst_n(rrst_n));

    fifomem #(DSIZE, ASIZE) fifomem (
        .rdata(rdata), .wdata(wdata),
        .waddr(waddr), .raddr(raddr),
        .wclken(winc), .wfull(wfull),
        .wclk(wclk)
    );

    rptr_empty #(ASIZE) read_control (
        .rempty(rempty),
        .raddr(raddr),
        .rptr(rptr), .rq2_wptr(rq2_wptr),
        .rinc(rinc), .rclk(rclk),
        .rrst_n(rrst_n)
    );

    wptr_full #(ASIZE) write_control (
        .wfull(wfull), .waddr(waddr),
        .wptr(wptr), .wq2_rptr(wq2_rptr),
        .winc(winc), .wclk(wclk),
        .wrst_n(wrst_n)
    );

endmodule


//Dual-port RAM

module fifomem #(parameter DATASIZE = 8, // Memory data word width
                 parameter ADDRSIZE = 4) // Number of mem address bits
    ( output [DATASIZE-1:0] rdata,
      input [DATASIZE-1:0] wdata,
      input [ADDRSIZE-1:0] waddr, raddr,
      input wclken, wfull, wclk
    );

    // RTL Verilog memory model
    localparam DEPTH = 1<<ADDRSIZE;
    reg [DATASIZE-1:0] mem [0:DEPTH-1];
    assign rdata = mem[raddr];
    always @(posedge wclk)
    if (wclken && !wfull) mem[waddr] <= wdata;

endmodule

//Read Control module

module rptr_empty #(parameter ADDRSIZE = 4)
    ( output reg rempty,
      output [ADDRSIZE-1:0] raddr,
      output reg [ADDRSIZE :0] rptr,
      input [ADDRSIZE :0] rq2_wptr,
      input rinc, rclk, rrst_n
    );

    reg [ADDRSIZE:0] rbin; //binary address - can be sent directly to the memory
    wire [ADDRSIZE:0] rgraynext, rbinnext;

    //-------------------
    // GRAY STYLE2 pointer
    //-------------------

    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n) 
            {rbin, rptr} <= 0;
        else 
            {rbin, rptr} <= {rbinnext, rgraynext};

    // Memory read-address pointer 
    assign raddr = rbin[ADDRSIZE-1:0];
    assign rbinnext = rbin + (rinc & ~rempty);
    assign rgraynext = (rbinnext>>1) ^ rbinnext; //Gray code generation

    //---------------------------------------------------------------
    // FIFO empty when :
    //    1) On reset
    //    2) next read_ptr == synchronized write_ptr
    //---------------------------------------------------------------
    assign rempty_val = (rgraynext == rq2_wptr);
    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n) 
            rempty <= 1'b1;
        else 
            rempty <= rempty_val;

endmodule

//Synchronizer for FIFO read pointer before sending to source domain

module sync_2ff #(parameter ADDRSIZE = 4)
    ( output reg [ADDRSIZE:0] ptr_sync,
      input [ADDRSIZE:0] ptr,
      input clk, rst_n
    );

    reg [ADDRSIZE:0] q1_ptr;

    always @(posedge clk or negedge rst_n)
    if (!rst_n) 
        {ptr_sync,q1_ptr} <= 0;
    else 
        {ptr_sync,q1_ptr} <= {q1_ptr,ptr};
endmodule

//Write Control Module

module wptr_full #(parameter ADDRSIZE = 4)
    ( output reg wfull,
      output [ADDRSIZE-1:0] waddr,
      output reg [ADDRSIZE :0] wptr,
      input [ADDRSIZE :0] wq2_rptr,
      input winc, wclk, wrst_n
    );

    reg [ADDRSIZE:0] wbin; //Binary address - can be sent directly to memory
    wire [ADDRSIZE:0] wgraynext, wbinnext;

    // GRAY pointer
    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n) 
            {wbin, wptr} <= 0;
        else 
            {wbin, wptr} <= {wbinnext, wgraynext};

    // Memory write-address pointer
    assign waddr = wbin[ADDRSIZE-1:0];
    assign wbinnext = wbin + (winc & ~wfull);
    assign wgraynext = (wbinnext>>1) ^ wbinnext;

    //------------------------------------------------------------------
    // Simplified version of the three necessary full-tests:
    // assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
    // (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
    // (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
    //------------------------------------------------------------------
    assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n) 
            wfull <= 1'b0;
        else 
            wfull <= wfull_val;

endmodule
