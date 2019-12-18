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
    wire dime_out1, dispense1, empty1, exact_change1, nickel_out1, two_dime_out1;
    wire dime_out2, dispense2, nickel_out2, two_dime_out2;
    wire dime_out3, dispense3, nickel_out3, two_dime_out3;
    wire coin_counter_failure;
    wire can_counter_failure;
    input [7:0] nickels;
    input [7:0] cans;
    input [7:0] dimes;

    // 2-valued failure detection mechanism
    coin_counter coins (
        exact_change, clk, reset, dimes[7:0], dime_out, load,
        nickels[7:0], nickel_out, two_dime_out
    );
    coin_counter coins1 (
        exact_change1, clk, reset, dimes[7:0], dime_out, load,
        nickels[7:0], nickel_out, two_dime_out
    );
    assign coin_counter_failure = (exact_change != exact_change1);

    // 2-valued failure detection mechanism
    can_counter drinks (
        clk, reset, load, cans[7:0], dispense, empty
    );
    can_counter drinks1 (
        clk, reset, load, cans[7:0], dispense, empty1
    );
    assign can_counter_failure = (empty != empty1);

    // 3-valued failure detection and correction mechanism
    drink_machine vending1 (
        nickel_in, dime_in, quarter_in, reset, clk, nickel_out1, dime_out1, two_dime_out1, dispense1
    );
    drink_machine vending2 (
        nickel_in, dime_in, quarter_in, reset, clk, nickel_out2, dime_out2, two_dime_out2, dispense2
        );
    drink_machine vending3 (
        nickel_in, dime_in, quarter_in, reset, clk, nickel_out3, dime_out3, two_dime_out3, dispense3
    );
    assign dime_out = (dime_out1 && dime_out2) || (dime_out1 && dime_out3) || (dime_out2 && dime_out3);
    assign nickel_out = (nickel_out1 && nickel_out2) || (nickel_out1 && nickel_out3) || (nickel_out2 && nickel_out3);
    assign two_dime_out = (two_dime_out1 && two_dime_out2) || (two_dime_out1 && two_dime_out3) || (two_dime_out2 && two_dime_out3);
    assign dispense = (dispense1 && dispense2) || (dispense1 && dispense3) || (dispense2 && dispense3);

    assign drink_machine_failure = (dime_out1 != dime_out2) || (dime_out1 != dime_out3) ||
                                   (two_dime_out1 != two_dime_out2) || (two_dime_out1 != two_dime_out3) ||
                                   (nickel_out1 != nickel_out2) || (nickel_out1 != nickel_out3) ||
                                   (dispense1 != dispense2) || (dispense1 != dispense3);

endmodule
