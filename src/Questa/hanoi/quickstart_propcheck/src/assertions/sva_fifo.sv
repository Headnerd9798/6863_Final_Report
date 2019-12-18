///////////////////////////////////////////////////////////////////////
//
//
//               Formal Verification CSEE E6863
//
//			sj, hz
//
//
///////////////////////////////////////////////////////////////////////
module fifo_checker_sva(clk,in_read_ctrl,in_write_ctrl,out_is_empty,out_is_full);
input clk;
input in_read_ctrl,in_write_ctrl;
input out_is_empty,out_is_full;

parameter ENTRIES = 4;

localparam [31:0] ENTRIES_LOG2 = $clog2(ENTRIES);

logic [ENTRIES_LOG2:0]  number_of_current_entries;
// Assume:

default clocking c0 @(posedge clk); endclocking

fifo_assume_empty: assume property (@(posedge clk) out_is_empty |-> ~in_read_ctrl );
fifo_assume_full: assume property (@(posedge clk) out_is_full |-> ~in_write_ctrl );

// Coverage: grant asserted
fifo_num_entries_6: cover property (number_of_current_entries == 6);

fifo_num_entries_5: cover property (number_of_current_entries == 5);

fifo_num_entries_4: cover property (number_of_current_entries == 4);

fifo_num_entries_3: cover property (number_of_current_entries == 3);

fifo_num_entries_2: cover property (number_of_current_entries == 2);

fifo_num_entries_1: cover property (number_of_current_entries == 1);

fifo_num_entries_0: cover property (number_of_current_entries == 0);


endmodule
