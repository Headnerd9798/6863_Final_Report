# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved. Unpublished -- rights reserved under the copyright 
#  laws of the United States.
# ----------------------------------------

check_unr -setup 

clock -none
reset -none

check_unr -prove -sil 
check_unr -list -type unreachable
check_unr -covgen -force

report -summary

exit 







