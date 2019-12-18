bind or1200_top jasper_csr_checker
   #(.ADDR_WIDTH(32),
    .DATA_WIDTH(32))
    jasper_csr_checker0 (
    .rstN(~rst_i),
    .clk(clk_i),
    .wr(du_write),
    .rd(du_read),
    .addr(du_addr),
    .din(du_dat_du),
    .dout(du_dat_cpu)
    );

