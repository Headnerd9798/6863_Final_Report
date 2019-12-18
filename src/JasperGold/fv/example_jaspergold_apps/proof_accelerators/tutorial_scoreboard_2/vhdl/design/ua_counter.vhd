library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY counter IS
PORT (
count72                 : OUT std_logic;
count8                  : OUT std_logic;
clk                     : IN std_logic;
enable                  : IN std_logic);
END counter;

ARCHITECTURE rtl OF counter IS
SIGNAL each8                    :  std_logic;
SIGNAL count_reg                :  std_logic_vector(8 DOWNTO 0);
SIGNAL count72_net              :  std_logic;
SIGNAL count8_net               :  std_logic;
BEGIN
count72 <= count72_net;
count8 <= count8_net;
PROCESS
BEGIN
WAIT UNTIL (clk'EVENT AND clk = '1');
IF (enable = '0') THEN
count_reg <= "000000000";
ELSE
count_reg <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(count_reg) + 1, 9);
END IF;
END PROCESS;
each8 <= '1' when (count_reg(2 DOWNTO 0) = "111") else '0' ;
count72_net <= '1' when (count_reg = "001000111") else '0' ;
count8_net <= each8 AND NOT count72_net ;
END rtl;


-- -------------------------------------------------------
-- Copyright (c) 2000 Jasper Design Automation, Inc.
--
-- All rights reserved.
--
-- Jasper Design Automation Proprietary and Confidential.
-- -------------------------------------------------------

