analyze -sv top.v
elaborate

clock clk1
clock clk2
reset -none

check_cdc -check -rule -set {{redundant_sync true}}

check_cdc -clock_domain -port {in2} -clock_signal clk2
check_cdc -clock_domain -port {in test_mode} -clock_signal clk1

check_cdc -clock_domain -find
check_cdc -pair -find
check_cdc -scheme -find
check_cdc -group -find
