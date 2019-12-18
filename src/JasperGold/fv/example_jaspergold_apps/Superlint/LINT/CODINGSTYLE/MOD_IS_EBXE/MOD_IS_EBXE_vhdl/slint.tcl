check_superlint -init
config_rtlds -rule -disable -domain all
config_rtlds -rule -enable -tag {MOD_IS_EBXE}
analyze -vhdl2k test.vhd
analyze -vhdl2k MOD_IS_EBXE.vhd
elaborate -bbox_m test
check_superlint -extract
