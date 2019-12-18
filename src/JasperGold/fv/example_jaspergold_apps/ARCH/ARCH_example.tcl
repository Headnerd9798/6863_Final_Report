# -------------------------------------------------------
# Copyright (c) 2017 Cadence Design Systems, Inc.
#
# All rights reserved.
#
# Jasper Design Automation Proprietary and Confidential.
# -------------------------------------------------------

clear -all
set_visualize_auto_check_props on

# Load the Archtectural Model
check_arch -load L1L2.xml

# Limit the proof time
set_prove_per_property_time_limit 10s
set_prove_time_limit 30s

# Prove the Arch Model
check_arch -prove

# Report results
report

# Visualize parts of the Arch Model
visualize -violation -property {<embedded>::L1L2.AST_table_L1_CMP_full} -new_window
