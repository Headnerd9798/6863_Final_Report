library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY start_detect IS
PORT (
valid                   : OUT std_logic;
clk                     : IN std_logic;
reset                   : IN std_logic;
gl_reset                : IN std_logic;
dIn                     : IN std_logic);
END start_detect;
ARCHITECTURE rtl OF start_detect IS
SIGNAL shift_reg                :  std_logic_vector(3 DOWNTO 0);
SIGNAL valid_net                :  std_logic;
BEGIN
valid <= valid_net;
PROCESS
BEGIN
WAIT UNTIL (clk'EVENT AND clk = '1');
IF ((reset OR gl_reset) = '1') THEN
shift_reg <= "0000";
ELSE
shift_reg <= shift_reg(2 DOWNTO 0) & dIn;
END IF;
END PROCESS;
valid_net <= '1' when (((shift_reg(0) = '0') AND (shift_reg(2) = '0'))
AND (shift_reg(3) = '1')) else '0' ;
END rtl;

-- -------------------------------------------------------
-- Copyright (c) 2000 Jasper Design Automation, Inc.
--
-- All rights reserved.
--
-- Jasper Design Automation Proprietary and Confidential.
-- -------------------------------------------------------

