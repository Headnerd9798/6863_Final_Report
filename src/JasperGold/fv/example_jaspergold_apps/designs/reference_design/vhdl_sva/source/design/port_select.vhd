-------------------------------------------------------------------------------
--                                                                           --
--  Module:  port_select                                                     --
--                                                                           --
--  Version: 13 July 2006                                                    --
-------------------------------------------------------------------------------

--************************************************************************
--
-- Copyright (C) 2000-2017 Cadence Design Systems, Inc. All Rights
-- Reserved.  Unpublished -- rights reserved under the copyright laws of
-- the United States.
--
-- The content of this file is owned by Cadence Design Systems, Inc.
-- and may be used only as authorized in the license agreement
-- controlling such use. No part of these materials may be reproduced,
-- transmitted, or translated, in any form or by any means, electronic,
-- mechanical, manual, optical, or otherwise, without prior written
-- permission of Cadence Design Systems, or as expressly provided by
-- the license agreement. These materials are for information and
-- instruction purposes.
--
-- For technical assistance please send email to support@cadence.com.
--
--***********************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity port_select is
  port (
    clk: in std_logic;
    ig_sel: in std_logic_vector(1 downto 0);
-- Ingress side
    int_read_write0: in std_logic;
    int_read_write1: in std_logic;
    int_read_write2: in std_logic;
    int_read_write3: in std_logic;
    int_valid0: in std_logic;
    int_valid1: in std_logic;
    int_valid2: in std_logic;
    int_valid3: in std_logic;
    trans_started0: in std_logic;
    trans_started1: in std_logic;
    trans_started2: in std_logic;
    trans_started3: in std_logic;
    current_read_write0: in std_logic;
    current_read_write1: in std_logic;
    current_read_write2: in std_logic;
    current_read_write3: in std_logic;
    int_size0: in std_logic_vector(1 downto 0);
    int_size1: in std_logic_vector(1 downto 0);
    int_size2: in std_logic_vector(1 downto 0);
    int_size3: in std_logic_vector(1 downto 0);
    int_addr_data0: in std_logic_vector(38 downto 0);
    int_addr_data1: in std_logic_vector(38 downto 0);
    int_addr_data2: in std_logic_vector(38 downto 0);
    int_addr_data3: in std_logic_vector(38 downto 0);
    int_ready0: out std_logic;
    int_ready1: out std_logic;
    int_ready2: out std_logic;
    int_ready3: out std_logic;
    new_tran0: out std_logic;
    new_tran1: out std_logic;
    new_tran2: out std_logic;
    new_tran3: out std_logic;
    int2ig_data0: out std_logic_vector(31 downto 0);
    int2ig_data1: out std_logic_vector(31 downto 0);
    int2ig_data2: out std_logic_vector(31 downto 0);
    int2ig_data3: out std_logic_vector(31 downto 0);
    int_read_done0: out std_logic;
    int_read_done1: out std_logic;
    int_read_done2: out std_logic;
    int_read_done3: out std_logic;
-- Egress side
    int_read_write: out std_logic;
    int_valid: out std_logic;
    trans_started: out std_logic;
    current_read_write: out std_logic;
    int_size: out std_logic_vector(1 downto 0);
    int_addr_data: out std_logic_vector(38 downto 0);
    int_ready: in std_logic;
    new_tran: in std_logic;
    int2ig_data: in std_logic_vector(31 downto 0);
    int_read_done: in std_logic
  );
end port_select;

architecture rtl of port_select is
begin

  int_ready0 <= int_ready when (ig_sel = "00") else '0';
  int_ready1 <= int_ready when (ig_sel = "01") else '0';
  int_ready2 <= int_ready when (ig_sel = "10") else '0';
  int_ready3 <= int_ready when (ig_sel = "11") else '0';

  int2ig_data0 <= int2ig_data;
  int2ig_data1 <= int2ig_data;
  int2ig_data2 <= int2ig_data;
  int2ig_data3 <= int2ig_data;

  new_tran0 <= new_tran when (ig_sel = "00") else '0';
  new_tran1 <= new_tran when (ig_sel = "01") else '0';
  new_tran2 <= new_tran when (ig_sel = "10") else '0';
  new_tran3 <= new_tran when (ig_sel = "11") else '0';

  int_read_done0 <= int_read_done when (ig_sel = "00") else '0';
  int_read_done1 <= int_read_done when (ig_sel = "01") else '0';
  int_read_done2 <= int_read_done when (ig_sel = "10") else '0';
  int_read_done3 <= int_read_done when (ig_sel = "11") else '0';

  int_size <=
              int_size0 when (ig_sel = "00")
         else int_size1 when (ig_sel = "01")
         else int_size2 when (ig_sel = "10")
         else int_size3;

  int_read_write <=
              int_read_write0 when (ig_sel = "00")
         else int_read_write1 when (ig_sel = "01")
         else int_read_write2 when (ig_sel = "10")
         else int_read_write3;

  int_valid <=
              int_valid0 when (ig_sel = "00")
         else int_valid1 when (ig_sel = "01")
         else int_valid2 when (ig_sel = "10")
         else int_valid3;

  trans_started <=
              trans_started0 when (ig_sel = "00")
         else trans_started1 when (ig_sel = "01")
         else trans_started2 when (ig_sel = "10")
         else trans_started3;

  current_read_write <=
              current_read_write0 when (ig_sel = "00")
         else current_read_write1 when (ig_sel = "01")
         else current_read_write2 when (ig_sel = "10")
         else current_read_write3;

  int_addr_data <=
              int_addr_data0 when (ig_sel = "00")
         else int_addr_data1 when (ig_sel = "01")
         else int_addr_data2 when (ig_sel = "10")
         else int_addr_data3;

end rtl;
