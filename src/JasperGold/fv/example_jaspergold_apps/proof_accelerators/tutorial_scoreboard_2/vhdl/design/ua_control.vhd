library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY control IS
PORT (
running                 : OUT std_logic;
clk                     : IN std_logic;
reset                   : IN std_logic;
gl_reset                : IN std_logic;
set                     : IN std_logic);
END control;
ARCHITECTURE rtl OF control IS
SIGNAL running_reg            :  std_logic;
BEGIN
running <= running_reg;
PROCESS
BEGIN
WAIT UNTIL (clk'EVENT AND clk = '1');
IF ((reset = '1') OR (gl_reset = '1')) THEN
running_reg <= '0';
ELSE
IF (set = '1') THEN
running_reg <= '1';
END IF;
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

