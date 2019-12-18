module fifo( clk, rst, in_read_ctrl, in_write_ctrl, in_write_data, 
             out_read_data, out_is_full, out_is_empty
             );

   
parameter
  ENTRIES = 4; 
  
localparam [31:0]  
  ENTRIES_LOG2 = $clog2(ENTRIES);
  
   input  logic       clk; 
   input  logic       rst;
   input  logic       in_read_ctrl;
   input  logic       in_write_ctrl;
   input  logic [7:0] in_write_data;
   output logic [7:0] out_read_data;
   output logic       out_is_full;
   output logic       out_is_empty;

   logic [ENTRIES_LOG2-1:0]  write_ptr;
   logic [ENTRIES_LOG2-1:0]  read_ptr;
   logic [ENTRIES-1:0] [7:0] fifo_data;
   logic [7:0]               head;
   logic [ENTRIES_LOG2:0]    number_of_current_entries; 
   
always_ff @(posedge clk) begin
   if (rst) begin
      write_ptr <= 0;
   end
   else if (in_write_ctrl) begin
      write_ptr <= write_ptr + 1'b1;
      fifo_data[write_ptr] <= in_write_data;
   end
end

always_comb begin
   head = fifo_data[read_ptr];
end
   
always_ff @(posedge clk) begin
   if (rst) begin
      read_ptr <= 0;
   end
   else if (in_read_ctrl) begin
      read_ptr <= read_ptr + 1'b1;
      out_read_data <= head;
   end
end

always_ff @(posedge clk) begin
   if (rst) begin
      number_of_current_entries <= 0;
      out_is_empty <= 1;
      out_is_full <= 0;
   end
   else if (in_read_ctrl & ~in_write_ctrl ) begin
      number_of_current_entries <= number_of_current_entries - 1'b1;
      out_is_full <= 0;
      out_is_empty <= (number_of_current_entries == 1'b1);       
   end
   else if (~in_read_ctrl & in_write_ctrl) begin
      number_of_current_entries <= number_of_current_entries + 1'b1;
      out_is_empty <= 0;
      out_is_full <= (number_of_current_entries == (ENTRIES-1'b1)); 
   end
    else if (~in_read_ctrl & ~in_write_ctrl) begin
      out_is_empty <= 0;
      out_is_full <= 0; 
   end
end

// 1. When FIFO is reset, empty flag is set high; full flag, write_ptr, read_ptr and number_of_current_entries are all set to 0. 
assert_reset: assert property (@(posedge clk) rst |=> (write_ptr == 0 && read_ptr == 0 && out_is_full == 0 && out_is_empty == 1 && number_of_current_entries == 0));	



// 2. When FIFO has no entry, it is empty.
assert_empty: assert property (@(posedge clk) (number_of_current_entries == 0) |-> out_is_empty);


	
// 3. When FIFO is empty, it should not be full (full flag set to 0).
assert_not_full: assert property (@(posedge clk) out_is_empty |-> !out_is_full);


	
// 4. When FIFO has only one entry with one read and no write, it will become empty in the next clock cycle. 
assert_become_empty: assert property (@(posedge clk) ((number_of_current_entries == 1) && (in_read_ctrl == 1) && (in_write_ctrl == 0)) |=> out_is_empty );



// 5. When FIFO is neither full nor empty, neither full flag nor empty flag should be set high. 
assert_neither_full_nor_empty: assert property (@(posedge clk) (((number_of_current_entries > 0) && (number_of_current_entries < ENTRIES))|-> (!out_is_full && !out_is_empty)));



// 6. When FIFO has N-1 entries with one write and no read, it will become full in the next clock cycle.
assert_become_full: assert property (@(posedge clk) ((number_of_current_entries == (ENTRIES - 1'b1)) && (in_read_ctrl == 0) && (in_write_ctrl == 1)) |=> out_is_full);



// 7. When the number of current entries has reached or exceeded the FIFO maximum entries N, it is full.
asser_full: assert property (@(posedge clk) (number_of_current_entries >= ENTRIES) |-> out_is_full);


	
// 8. When FIFO is full, it should not be empty (empty flag set to 0).
assert_not_empty: assert property (@(posedge clk) out_is_full |-> !out_is_empty );	





endmodule






