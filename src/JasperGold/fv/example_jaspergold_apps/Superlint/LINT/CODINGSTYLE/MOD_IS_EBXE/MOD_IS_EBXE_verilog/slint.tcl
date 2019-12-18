check_superlint -init
config_rtlds -rule -disable -domain all
config_rtlds -rule -enable -tag {MOD_IS_EBXE}
analyze -sv MOD_IS_EBXE.v
elaborate -bbox_m mod_2
check_superlint -extract
