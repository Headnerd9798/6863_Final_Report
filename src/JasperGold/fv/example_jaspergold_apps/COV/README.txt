Quick introduction to the Coverage (COV) App.
To run:
  jg -cov COV_verilog_sva_example.tcl  
or
  jg -cov COV_vhdl_sva_example.tcl

###############################################
# 1) Make sure Coverage GUI is open
#     - If not, click View->Applications->Coverage
# 2) Wait until engines have finished running (approx. 1 minute)
#     - After engines have finished, coverage summary columns can be viewed in the hierarchy pane for Stimuli, COI, and Proof coverage
#     - NOTE: you may need to expand the pane size in upper left corner to see the results
#     - Use the following steps to display a detailed view of each coverage type with source code highlighting
# 3) Stimuli Coverage: View unreachable cover items in <embedded> task
#     - Click "Report Coverage" button under Coverage Analysis at top of screen
#     - Coverage Report Type = Unreachable, Task Name = <embedded> 
#     - Click OK
#     - Unreachable cover items are highlighted in source code, and summarized in hierarchy pane
#     - Click "C" forward/back navigation buttons at top of browser to find unreachable code - items in Cover Items Table will also highlight
#     - Optional: Run report again, deselecting "Reset" to see reset-related unreachable covers that were been automatically filtered out
# 4) COI Coverage: View out-of-COI report
#     - Click "Report Coverage" button under Coverage Analysis at top of screen
#     - Coverage Report Type = Out of COI, Task Name = <embedded>
#     - Click OK
#     - Cover items not included in any COI are highlighted in source code, and summarized in hierarchy pane
#     - These represent design areas which are not being checked by any assertions
# 4) Proof Coverage: View out-of-proof core report
#     - Click "Report Coverage" button under Coverage Analysis at top of screen
#     - Coverage Report Type = Out of Proof Core, Task Name = <embedded>
#     - Click OK
#     - Cover items not verified by formal engines during proofs (outside of proof core) are reported
#     - These indicate further holes in the verification - logic that was not necessary for the engines to establish a proof
# 5) Bound Coverage: Show the Bounded report for the bounded proof of an assertion
#     - In Assert Table, select one of the asserts with a bounded proof (yellow "?")
#     - Click "Report Coverage" button under Coverage Analysis at top of screen
#     - Coverage Report Type = Bounded, Task Name = <embedded>
#     - Click OK
#     - Cover items only reachable beyond the assertion bound (Unconfirmed Covers) are highlighted
#     - This indicates that some design code has not been verified within the cycle count of the bounded proof, and proof bound may be insufficient
#     - Use "C" forward/back navigation buttons to highlight
#     - Bound of each cover item is displayed to the right of the source code line
# 6) Optional - Generate offline HTML report
#     - Click "Report Coverage" button
#     - Select "All Cover Items" report type
#     - Click Advanced Options tab -> Extract to File
#     - Select File, HTML report format, and enter filename
#     - Click "Ok"
# 7) Optional - Show Waiver capability for cover items that should be ignored
#     - Click Cover Items Table
#     - Right click on a cover item and select "Waive"
#     - Type a comment
#     - Click Waiver List tab in Source Browser and show that the waiver has been added
#     - Re-run the report, with "Exclude Waived" selected under Advanced Options tab, and hit OK
#     - Waived item is excluded from the new report
