library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Use the Jasper PPM package
library jasper_package;
use     jasper_package.jasper_package.all;

ENTITY datapath IS
PORT (
clk                     : IN std_logic;
rstN                    : IN std_logic;
tx_error                : IN std_logic;
valid_in                : IN std_logic;
data_in                 : IN std_logic;
valid_out               : IN std_logic;
data_out                : IN std_logic_vector(7 DOWNTO 0));
END datapath;

ARCHITECTURE rtl OF datapath IS
BEGIN

dp : jasper_scoreboard_2
  generic map (
    IN_PORT_COUNT  => 1,
    OUT_PORT_COUNT => 8
  )
  port map (
    clk1 => clk,
    clk2 => clk,
    rst1N => ( rstN and not tx_error ),
    rst2N => ( rstN and not tx_error ),

    incoming_vld  => ( 0 => valid_in ),
    incoming_data => ( 0 => data_in ),

    outgoing_vld  => ( others => valid_out ),
    outgoing_data => ( data_out ),

    random_packet_selected => open,
    selected_packet_exits  => open,

    random_packet_selected_pport => open,
    selected_packet_exits_pport => open,

    polarity => open
  );

END rtl;


-- -------------------------------------------------------
-- Copyright (c) 2000 Jasper Design Automation, Inc.
--
-- All rights reserved.
--
-- Jasper Design Automation Proprietary and Confidential.
-- -------------------------------------------------------

