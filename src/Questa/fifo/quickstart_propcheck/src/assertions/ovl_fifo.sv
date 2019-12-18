///////////////////////////////////////////////////////////////////////
//
//
//               Formal Verification CSEE E6863
//
//			sj, hz
//
//
///////////////////////////////////////////////////////////////////////

module fifo_checker_ovl(clk, rst, in_read_ctrl, in_write_ctrl, out_is_empty, out_is_full);
input clk, rst;
input in_read_ctrl, in_write_ctrl;
input out_is_empty, out_is_full;

default clocking c0 @(posedge clk); endclocking

fifo_assume_empty: assume property (@(posedge clk) out_is_empty |-> ~in_read_ctrl );
fifo_assume_full: assume property (@(posedge clk) out_is_full |-> ~in_write_ctrl );

wire [2:0] fifo_index_fire;
ovl_fifo_index #(.depth(4))
    fifo_index_check(
    .clock(clk),		.reset(!rst),
    .enable(1'b1),		.push(in_write_ctrl),
    .pop(in_read_ctrl),	        .fire(fifo_index_fire));

endmodule
