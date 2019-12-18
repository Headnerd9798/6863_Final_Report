
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.fifo_package.all;

package fifo_configure is

--***************************************************************
-- definition of custom amba system parameters
--***************************************************************

--***************************************************************
-- AMBA SLAVES address configuration space
--***************************************************************
--For every slave define HIGH and LOW address, before and after (r)emap

constant n_u: addr_t := (0, 0);


constant pslv_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));

constant  ahb_slv0: addr_t := (1023, 0);
constant rahb_slv0: addr_t := (1023, 0);

constant slv_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,rahb_slv0),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,ahb_slv0));

constant arb_matrix: addr_matrix_t(1 downto 0):= (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,ahb_slv0),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,ahb_slv0));

constant rarb_matrix: addr_matrix_t(1 downto 0):= (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,rahb_slv0),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,rahb_slv0));

constant ahbbrg_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));

constant rahbbrg_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));

constant apbbrg_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));

constant rapbbrg_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));



end;

package body fifo_configure is
end;


-- -------------------------------------------------------
-- Copyright (c) 2000 Jasper Design Automation, Inc.
--
-- All rights reserved.
--
-- Jasper Design Automation Proprietary and Confidential.
-- -------------------------------------------------------


