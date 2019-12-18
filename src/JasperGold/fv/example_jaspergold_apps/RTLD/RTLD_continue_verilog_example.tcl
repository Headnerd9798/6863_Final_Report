# ----------------------------------------
#  Copyright (c) 2017 Cadence Design Systems, Inc. All Rights
#  Reserved.  Unpublished -- rights reserved under the copyright laws of
#  the United States.
# ----------------------------------------

# The steps in this example correspond to the typical GUI interaction
# you would do with the RTL Development App (RTLD) when starting 
# analysis of a new RTL.
# ----------------------------------------

#
# e.g. on loading the database
# GUI: "File -> Open Database..." drop-down menu
#
restore -jdb [get_proj_dir]/example.jdb

#
# e.g. on re-extracting the structural information on the revised RTL
# GUI: "Application -> Structural Analysis" drop-down menu
# GUI: "Reports -> Export Report as CSV File" drop-down menu
#
database -structural_analysis -batch
database -export_report "Structural Differences" [get_proj_dir]/sa.csv

#
# e.g. on re-generating the waveforms and comparing to the baseline
# GUI: "Application -> Behavioral Analysis" drop-down menu
# GUI: "Reports -> Export Report as CSV File" drop-down menu
#
database -behavioral_analysis -include_behaviors -batch
database -export_report "Behavioral Differences" [get_proj_dir]/ba.csv

#
# e.g. ask a new question while leveraging existing data
# GUI: Right-click menu item "Visualize Behavior in Current Session" on a Behavior element
# GUI: Drag-and-drop behavior from the Indexed Behaviors table to the recipe constraints list on
# the right-hand side of the waveform viewer
# GUI: "Replot" icon in the middle of the toolbar at the top of the waveform viewer
# GUI: "Capture Recipe" icon, last toolbar icon at the top-right corner of the waveform viewer
#
visualize -property {<embedded>::behavior:0}
visualize -at_least_once -property {<embedded>::behavior:1}
visualize -at_least_once -property {<embedded>::Transfer_Start}
visualize -replot
database -set_focus 0
visualize -save_recipe {Another recipe} -task <embedded> -save_signal_order \
-description {Reusing three existing behaviors and combining them into one single waveform} -batch
