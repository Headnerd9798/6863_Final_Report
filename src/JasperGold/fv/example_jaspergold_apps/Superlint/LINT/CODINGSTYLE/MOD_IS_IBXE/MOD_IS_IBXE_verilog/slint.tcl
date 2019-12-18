check_superlint -init
config_rtlds -rule -disable -domain all
config_rtlds -rule -enable -tag {MOD_IS_IBXE}
analyze -sv MOD_IS_IBXE.v
elaborate -bbox 1
check_superlint -extract
