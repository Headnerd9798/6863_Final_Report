// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module pulse(input clk1, clk2, rst1, rst2, pulse_in, output pulse_out);

reg src, dst, dff_out, prev_out;

always @(posedge clk1 or posedge rst1) begin
    if (rst1) begin
        src <= 1'b0;
    end else begin
        src <= pulse_in ? ~src : src;
    end
end

always @(posedge clk2 or posedge rst2) begin
    if (rst2) begin
        dst      <= 1'b0;
        dff_out  <= 1'b0;
        prev_out <= 1'b0;
    end else begin
        dst      <= src;
        dff_out  <= dst;
        prev_out <= dff_out;
    end
end

assign pulse_out = dff_out ^ prev_out;
endmodule
