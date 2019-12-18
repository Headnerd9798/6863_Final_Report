`define ADDR_CUSTOM_KEY     12'h400
`define ADDR_KEY_SELECT     12'h401
`define ADDR_OTP_PROG       12'h402

`define ADDR_HASH_ADDR      12'h800
`define ADDR_HASH_EXPECTED  12'h801
`define ADDR_HASH_DATA      12'h802
`define ADDR_HASH_START     12'h803
`define ADDR_HASH_CLEAR     12'h804
`define ADDR_HASH_STATUS    12'h805

`define HASH_STATUS_BUSY    32'h0000_0001
`define HASH_STATUS_PASS    32'h0000_0010
`define HASH_STATUS_FAIL    32'h0000_1111

`define KEY_SELECT_CUSTOM   1'b0
`define KEY_SELECT_OTP      1'b1

//`define FIX1
//`define FIX2

