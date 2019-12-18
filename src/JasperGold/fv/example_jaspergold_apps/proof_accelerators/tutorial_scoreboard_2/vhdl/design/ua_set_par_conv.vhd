library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY ser_par_conv IS
PORT (
dOut                    : OUT std_logic_vector(7 DOWNTO 0);
clk                     : IN std_logic;
enable                  : IN std_logic;
dIn                     : IN std_logic);
END ser_par_conv;
ARCHITECTURE rtl OF ser_par_conv IS
SIGNAL dOut_reg               :  std_logic_vector(7 DOWNTO 0);
BEGIN
dOut <= dOut_reg;
PROCESS
BEGIN
WAIT UNTIL (clk'EVENT AND clk = '1');
IF (enable = '1') THEN
dOut_reg <= dIn & dOut_reg(7 DOWNTO 1);
END IF;
END PROCESS;
END rtl;


-- -------------------------------------------------------
-- Copyright (c) 2000 Jasper Design Automation, Inc.
--
-- All rights reserved.
--
-- Jasper Design Automation Proprietary and Confidential.
-- -------------------------------------------------------

