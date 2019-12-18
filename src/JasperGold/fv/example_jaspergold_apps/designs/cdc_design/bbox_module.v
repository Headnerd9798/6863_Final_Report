// -------------------------------------------------------
// Copyright (c) 2017 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// -------------------------------------------------------

module modreg_bank (prst_n_i, pclk_i, penable_i, paddr_i, pwrite_i, pwdata_i, pmodsel_i, prdata_o);

input         prst_n_i;
input         pclk_i;
input         penable_i;
input  [15:0] paddr_i;
input         pwrite_i;
input  [31:0] pwdata_i;
input         pmodsel_i;
output [31:0] prdata_o;

reg [24095:0][31:0] reg_bank;
endmodule
