library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;
use     IEEE.std_logic_unsigned.ALL;

library jasper_package;
use     jasper_package.jasper_package.all;

entity FIFO_datapath is
  port (
  clk       : in std_logic;
  rstN      : in std_logic;
  valid_in  : in std_logic; -- push strobe, active high
  valid_out : in std_logic; -- pop strobe, active high
  data_in   : in std_logic_vector(31 downto 0);
  data_out  : in std_logic_vector(31 downto 0)
);
end FIFO_datapath;

architecture rtl of FIFO_datapath is
begin

  dp : jasper_scoreboard_priority
    generic map (
      PKT_LATENCY     => 8,
      LOG_PKT_LATENCY => 5,
      PAYLOAD_SIZE    => 32
    )
    port map (
      clk1  => clk,
      clk2  => clk,
      rst1N => rstN,
      rst2N => rstN,

      incoming_sop   => valid_in,
      incoming_eop   => valid_in,
      incoming_vld   => valid_in,
      incoming_data  => data_in,

      outgoing_sop   => valid_out,
      outgoing_eop   => valid_out,
      outgoing_vld   => valid_out,
      outgoing_data  => data_out,

      port_valid     => ( '1' ),
      duplicated     => ( '0' ),
      priority_in       => "0"
    );

end rtl;


-- -------------------------------------------------------
-- Copyright (c) 2000 Jasper Design Automation, Inc.
--
-- All rights reserved.
--
-- Jasper Design Automation Proprietary and Confidential.
-- -------------------------------------------------------

