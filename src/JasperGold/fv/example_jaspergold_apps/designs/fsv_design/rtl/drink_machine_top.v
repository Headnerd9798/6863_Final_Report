// -------------------------------------------------------
// Copyright (c) 2018 Cadence Design Systems, Inc.
//
// All rights reserved.
//
// Cadence Design Systems Proprietary and Confidential.
// ------------------------------------------------------

module drink_machine_top( 
        dime_out, dispense, empty, exact_change,
        nickel_out, two_dime_out, cans, clk, dimes, dime_in, load,
        nickels, nickel_in, quarter_in, reset 
    );

    input clk, dime_in, load, nickel_in, quarter_in, reset;
    output dime_out, dispense, empty, exact_change, nickel_out, two_dime_out;
    input [7:0] nickels;
    input [7:0] cans;
    input [7:0] dimes;

    coin_counter coins (
        exact_change, clk, reset, dimes[7:0], dime_out, load,
        nickels[7:0], nickel_out, two_dime_out
    );
    can_counter drinks (
        clk, reset, load, cans[7:0], dispense, empty
    );
    drink_machine vending (
        nickel_in, dime_in, quarter_in, reset, clk, nickel_out, dime_out, two_dime_out, dispense
    );

endmodule
