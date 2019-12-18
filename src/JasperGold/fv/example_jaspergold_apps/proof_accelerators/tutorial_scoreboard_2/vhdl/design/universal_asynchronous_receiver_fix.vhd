library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY uar IS
PORT (
dOut                    : OUT std_logic_vector(7 DOWNTO 0);
dReady                  : OUT std_logic;
dError                  : OUT std_logic;
clk                     : IN std_logic;
gl_reset                : IN std_logic;
dIn                     : IN std_logic);
END uar;
ARCHITECTURE rtl OF uar IS
COMPONENT control
PORT (
running                 : OUT std_logic;
clk                     : IN  std_logic;
reset                   : IN  std_logic;
gl_reset                : IN  std_logic;
set                     : IN  std_logic);
END COMPONENT;
COMPONENT counter
PORT (
count72                 : OUT std_logic;
count8                  : OUT std_logic;
clk                     : IN  std_logic;
enable                  : IN  std_logic);
END COMPONENT;
COMPONENT flags
PORT (
dReady                  : OUT std_logic;
dError                  : OUT std_logic;
clk                     : IN  std_logic;
set                     : IN  std_logic;
gl_reset                : IN  std_logic;
reset                   : IN  std_logic;
dIn                     : IN  std_logic);
END COMPONENT;

COMPONENT ser_par_conv
PORT (
dOut                    : OUT std_logic_vector(7 DOWNTO 0);
clk                     : IN  std_logic;
enable                  : IN  std_logic;
dIn                     : IN  std_logic);
END COMPONENT;
COMPONENT start_detect
PORT (
valid                   : OUT std_logic;
clk                     : IN  std_logic;
reset                   : IN  std_logic;
gl_reset                : IN  std_logic;
dIn                     : IN  std_logic);
END COMPONENT;
SIGNAL running                  :  std_logic;
SIGNAL finish                   :  std_logic;
SIGNAL count8                   :  std_logic;
SIGNAL start                    :  std_logic;

BEGIN
s_d : start_detect

PORT MAP (
valid => start,
clk => clk,
reset => running,
gl_reset => gl_reset,
dIn => dIn);
cov : counter

PORT MAP (
count72 => finish,
count8 => count8,
clk => clk,
enable => running);
s_p : ser_par_conv

PORT MAP (
dOut => dOut,
clk => clk,
enable => count8,
dIn => dIn);
fla : flags

PORT MAP (
dReady => dReady,
dError => dError,
clk => clk,
set => finish,
gl_reset => gl_reset,
reset => start,
dIn => dIn);

con : control
PORT MAP (
running => running,
clk => clk,
reset => finish,
gl_reset => gl_reset,
set => start);

END rtl;


-- -------------------------------------------------------
-- Copyright (c) 2000 Jasper Design Automation, Inc.
--
-- All rights reserved.
--
-- Jasper Design Automation Proprietary and Confidential.
-- -------------------------------------------------------

