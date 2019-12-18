Perspective_Version   1
#
pref::section perspective 
set perspective_Name      qverify
set perspective_DateTime  2019-12-17T20:41:18
set perspective_Directory /homes/user/stud/fall19/hz2619/hanoi54/quickstart_propcheck
set perspective_USER      hz2619
set perspective_VisId   2019.2_1
#
pref::section preference 
pref::set -type bool -category General -name PromptForWavefile -value false -hide -description {Operations that require a wave file will trigger a prompt for wave file if this value is true,
otherwise the operation will be disabled} -label {Prompt for wavefile as needed}
pref::set -type bool -category General -name AutoReloadOnFault -value false -hide -description {If the tool should recieve a fatal signal, this preference indicates whether it should attmept to automatically restart.} -label {Automatically restart if a signal fault occurs.}
pref::set -type font -category General.Font -name ApplicationFont -value {Liberation Sans,12,-1,5,50,0,0,0,0,0} -description {Specifies the application font to use if the preference to
override the system default font is true} -label {Application Font}
pref::set -type font -category General.Font -name WindowFont -value {Liberation Sans,12,-1,5,50,0,0,0,0,0} -description {Specifies the font for window titles} -label {Window Font}
pref::set -type font -category General.Font -name TooltipFont -value {Liberation Sans,12,-1,5,50,0,0,0,0,0} -description {Specifies the font for tooltips} -label {Tooltip Font}
pref::set -type bool -category {Source Browser} -name EnableValueTooltip -value true -description {Tooltips containing signal values will appear if the mouse hovers over a signal name} -label {Enable Value Tooltip}
pref::set -type bool -category {Source Browser} -name EnableExecutionTrace -value false -hide -description {Enable Execution Trace} -label {Enable Execution Trace}
pref::set -type bool -category Waveform -name PanToCursor -value false -description {Pan wave window to primary cursor time if true} -label {Pan to Primary Cursor Time}
pref::set -type string -category Waveform -name waveConfigFile -value {} -description {<p style='white-space: pre'>A file to be loaded every time a wave window is opened.<br><i>It may contain any valid Tcl command.} -label {Load this file each time}
pref::set -type font -category Waveform.Font -name WaveformFont -value {Liberation Sans,12,-1,5,50,0,0,0,0,0} -description {Font used within wave window for signal, names, values, etc.} -label {Waveform Font}
pref::set -type category -value Schematic -hide
pref::set -type category -value Design -hide
pref::set -type category -value {Browse Menu} -hide
pref::set -type int -category {Driver Receiver} -name DriverReceiverMax -value 10000 -description {<p style='white-space: pre'>Maximum number of driver/receiver<br>objects to be shown in the window.<br>Note: Change is seen in next session.<br>Note: Use a value of "0" to restore the default.} -label {Maximum displayed drivers / receivers}
pref::set -type category -value Files -hide
pref::set -type category -value {UVM Testbench} -hide
pref::set -type category -value Breakpoints -hide
pref::set -type category -value CallStack -hide
pref::set -type category -value Classes -hide
pref::set -type category -value {Class Instance} -hide
pref::set -type category -value Locals -hide
pref::set -type category -value {Memory Usage} -hide
pref::set -type category -value Sequence -hide
pref::set -type category -value Threads -hide
pref::set -type category -value {UVM Configuration} -hide
pref::set -type category -value {UVM Factory} -hide
pref::set -type category -value Watch -hide
pref::set -type category -value {Event Order} -hide
pref::set -type category -value ATV -hide
pref::set -type category -value LiveSim -hide
pref::set -type category -value PropCheck
pref::set -type bool -category PropCheck -name confirmExitStopsRun -value true -description {<p style='white-space: pre'>Show confirmation when exiting and a run is in-progress.<br>Unselecting this option will automatically terminate<br>a run that is in-progress.} -label {Confirm exiting will stop an in-progress run}
pref::set -type string -category PropCheck -name formalControlPointsRadixType -value b -hide -description none -label none
pref::set -type category -value PropCheck.Color
pref::set -type color -category PropCheck.Color -name contribWaveAnnoColor -value #3c5e36 -description {<p style='white-space: pre'>Color used in wave window to identify ranges of times for which<br>a contributing signal's values are relevant for the firing.<br>Note: Change not applied to currently visible waveforms.} -label {Contributor time regions}
pref::set -type category -value PropCheck.Properties
pref::set -type bool -category PropCheck.Properties -name collapseControlPoints -value false -description {<p style='white-space: pre'>By default, the Control Points waveform group is shown<br>expanded. This option will show the group initially collapsed.} -label {Show Control Points waveform group collapsed}
pref::set -type bool -category PropCheck.Properties -name showContribs -value false -description {Include contributor signals when showing waveforms} -label {Show contributor signals}
pref::set -type bool -category PropCheck.Properties -name dontCaresX -value false -description {<p style='white-space: pre'>By default, waveforms use 0's for the don't care<br>values. This option applies X's instead. The X's<br>propagate using the semantic rules for X propagation.} -label {Use X for don't care values on control points}
pref::set -type int -category PropCheck.Properties -name extraCycles -value 1 -description {<p style='white-space: pre'>Include in the waveform the specified number<br>of cycles after the cycle with the firing} -label {Number of cycles after firing}
pref::set -type bool -category PropCheck.Properties -name showCountsSummary -value false -hide -description none -label none
pref::set -type category -value PropCheck.table_columns -hide
pref::set -type string -category PropCheck.table_columns -name propcheck_Table -value %00%00%00%FF%00%00%00%00%00%00%00%01%00%00%00%01%00%00%00%08%01%00%00%00%00%00%00%00%00%00%00%00%13%E6%F2%06%00%00%00%0C%00%00%00%0F%00%00%00%B2%00%00%00%09%00%00%00%85%00%00%00%05%00%00%002%00%00%00%06%00%00%002%00%00%00%07%00%00%00%28%00%00%00%01%00%00%00d%00%00%00%02%00%00%00%19%00%00%00%11%00%00%02%15%00%00%00%12%00%00%00d%00%00%00%0C%00%00%00%B2%00%00%00%0D%00%00%00%3C%00%00%00%0E%00%00%00%B2%00%00%06j%00%00%00%13%01%01%00%01%00%00%00%00%00%00%00%00%00%00%00%00d%FF%FF%FF%FF%00%00%00%01%00%00%00%00%00%00%00%13%00%00%00%19%00%00%00%01%00%00%00%02%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%02%00%00%00%28%00%00%00%01%00%00%00%02%00%00%00%28%00%00%00%01%00%00%00%02%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%02%00%00%02%FC%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00P%00%00%00%01%00%00%00%02%00%00%00%B2%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%02%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%02%03%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%03%E8%00%00%00%00Y -description unused -label unused
pref::set -type string -category PropCheck.table_columns -name propcheck_Table_signature -value {,SEQ#,,,,Sc,Vc,Dc,Name,Groups,Health,Radius,Absolute Radius,Cov,Module,Instance,Time,File,} -description unused -label unused
pref::set -type string -category PropCheck.table_columns -name descheck_Table -value %00%00%00%FF%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%01%01%00%00%00%00%00%00%00%00%00%00%00%07%01%00%00%00%01%00%00%00%00%00%00%00d%00%00%07%FE%00%00%00%07%01%01%00%01%00%00%00%00%00%00%00%00%00%00%00%00d%FF%FF%FF%FF%00%00%00%01%00%00%00%00%00%00%00%07%00%00%00%00%00%00%00%01%00%00%00%00%00%00%01%0B%00%00%00%01%00%00%00%00%00%00%01%0B%00%00%00%01%00%00%00%00%00%00%01%0B%00%00%00%01%00%00%00%00%00%00%01%BD%00%00%00%01%00%00%00%00%00%00%01%0B%00%00%00%01%00%00%00%00%00%00%02%15%00%00%00%01%00%00%00%00%00%00%03%E8%00%00%00%02%15 -description unused -label unused
pref::set -type string -category PropCheck.table_columns -name descheck_Table_signature -value SEQ#,Type,Name,Module,Instance,ID,File -description unused -label unused
pref::set -type category -value PropCheck.table_columns_2 -hide
pref::set -type string -category PropCheck.table_columns_2 -name propcheck_Table -value %00%00%00%FF%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%04%01%00%00%00%00%00%00%00%00%00%00%00%13%E6%F2%06%00%00%00%0C%00%00%00%0C%00%00%00%B2%00%00%00%09%00%00%00%85%00%00%00%07%00%00%00%28%00%00%00%06%00%00%002%00%00%00%05%00%00%002%00%00%00%02%00%00%00%19%00%00%00%01%00%00%00d%00%00%00%12%00%00%00d%00%00%00%11%00%00%02%15%00%00%00%0F%00%00%00%B2%00%00%00%0E%00%00%00%B2%00%00%00%0D%00%00%00%3C%00%00%06j%00%00%00%13%01%01%00%01%00%00%00%00%00%00%00%00%00%00%00%00d%FF%FF%FF%FF%00%00%00%01%00%00%00%00%00%00%00%13%00%00%00%19%00%00%00%01%00%00%00%02%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%02%00%00%00%28%00%00%00%01%00%00%00%02%00%00%00%28%00%00%00%01%00%00%00%02%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%02%00%00%01%BD%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00P%00%00%00%01%00%00%00%02%00%00%00%B2%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%02%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%03B%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%00%00%00%03%E8%00%00%00%00Y -description unused -label unused
pref::set -type string -category PropCheck.table_columns_2 -name propcheck_Table_signature -value {,SEQ#,,,,Sc,Vc,Dc,Name,Groups,Health,Radius,Absolute Radius,Cov,Module,Instance,Time,File,} -description unused -label unused
pref::set -type category -value {Delta List} -hide
pref::set -type category -value WindowColumns -hide
pref::set -type string -category WindowColumns -name WaveX_waveFormWinCls_waveHeader -value %00%00%00%FF%00%00%00%00%00%00%00%01%00%00%00%00%00%00%00%05%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%15%93%00%00%00%06%00%01%00%00%00%00%00%00%00%00%00%00%00%00%00%00d%FF%FF%FF%FF%00%00%00%84%00%00%00%00%00%00%00%06%00%00%00%1D%00%00%00%01%00%00%00%02%00%00%01%9C%00%00%00%01%00%00%00%00%00%00%00R%00%00%00%01%00%00%00%00%00%00%00%00%00%00%00%01%00%00%00%02%00%00%00%00%00%00%00%01%00%00%00%02%00%00%13%88%00%00%00%01%00%00%00%00%00%00%03%E8%00%00%00%00%00 -hide
Perspective_Complete
