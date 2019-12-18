8-deep FIFO (First-In First-Out)

Jasper's "jasper_scoreboard_priority" PA checks for correct data transfer
through the DUV, i.e. the data at the output is output in the same order as
it is received.

The FIFO exhibits incorrect behavior when overflow (write operation while FIFO
is full) or underflow (read operation while FIFO is empty) conditions occur
based on the primary inputs behavior.

Scripts:
- test.tcl :    Detection of incorrect data order due to overflow or underflow
                conditions
- test_ok.tcl : Complete proof of data transfer with appropriate constraints
                preventing overflow or underflow conditions
