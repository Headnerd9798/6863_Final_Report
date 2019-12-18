Serial-to-parallel Universal Receiver

Jasper's "jasper_scoreboard_2" PA detects conditions where data is lost,
corrupted or duplicated in the DUV.

There are two functional errors in the original RTL preventing correct data
transfer detected by JasperGold.

- Data ready signal is not initialized through global reset
  -> Data is output without incoming data

- Data ready signal is not de-asserted after the cycle it is asserted;
  it would require the reset signal based on incoming data to assert
  -> Data is output without incoming data due to ready signal asserted twice

Scripts:
- test.tcl :     Detection of error conditions in module "flags"
- test_fix.tcl : Complete proof of data transfer
