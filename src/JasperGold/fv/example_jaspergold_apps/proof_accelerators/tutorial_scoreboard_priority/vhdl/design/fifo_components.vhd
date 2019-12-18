library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.fifo_package.all;
use work.fifo_funct.all;
use work.fifo_configure.all;

package fifo_components is

component fifo
generic (
  fifohempty_level: in integer:= 1;
  fifohfull_level: in integer:= 3;
  fifo_length: in integer:= 4);
port (
  hresetn: in std_logic;
  clk: in std_logic;
  fifo_reset: in std_logic;
  fifo_write: in std_logic;
  fifo_read: in std_logic;
  fifo_count: out std_logic_vector(nb_bits(fifo_length)-1 downto 0);
  fifo_full: out std_logic;
  fifo_hfull: out std_logic;
  fifo_empty: out std_logic;
  fifo_hempty: out std_logic;
  fifo_datain: in std_logic_vector(31 downto 0);
  fifo_dataout: out std_logic_vector(31 downto 0)
  );
end component;

end;

package body fifo_components is
end;


-- -------------------------------------------------------
-- Copyright (c) 2000 Jasper Design Automation, Inc.
--
-- All rights reserved.
--
-- Jasper Design Automation Proprietary and Confidential.
-- -------------------------------------------------------


