-------------------------------------------------------------------------------
--                                                                           --
--  Module:  top                                                             --
--                                                                           --
--  Description: 4-to-1 switch                                               --
--                                                                           --
--  Version: 13 July 2006                                                    --
-------------------------------------------------------------------------------

--************************************************************************
--
-- Copyright (C) 2017 Cadence Design Systems, Inc. All Rights
-- Reserved.  Unpublished -- rights reserved under the copyright laws of
-- the United States.
--
-- The content of this file is owned by Jasper Design Automation, Inc.
-- and may be used only as authorized in the license agreement
-- controlling such use. No part of these materials may be reproduced,
-- transmitted, or translated, in any form or by any means, electronic,
-- mechanical, manual, optical, or otherwise, without prior written
-- permission of Jasper Design Automation, or as expressly provided by
-- the license agreement. These materials are for information and
-- instruction purposes.
--
-- For technical assistance please send email to support@jasper-da.com.
--
--***********************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
clk: in std_logic;
rstN: in std_logic;
  addr0: in std_logic_vector(6 downto 0);
  valid0: in std_logic;
  ready0: out std_logic;
  wr_rd0: in std_logic;
  rdata0: out std_logic_vector(31 downto 0);
  wdata0: in std_logic_vector(31 downto 0);
  size0: in std_logic_vector(1 downto 0);
  addr1: in std_logic_vector(6 downto 0);
  valid1: in std_logic;
  ready1: out std_logic;
  wr_rd1: in std_logic;
  rdata1: out std_logic_vector(31 downto 0);
  wdata1: in std_logic_vector(31 downto 0);
  size1: in std_logic_vector(1 downto 0);
  addr2: in std_logic_vector(6 downto 0);
  valid2: in std_logic;
  ready2: out std_logic;
  wr_rd2: in std_logic;
  rdata2: out std_logic_vector(31 downto 0);
  wdata2: in std_logic_vector(31 downto 0);
  size2: in std_logic_vector(1 downto 0);
  addr3: in std_logic_vector(6 downto 0);
  valid3: in std_logic;
  ready3: out std_logic;
  wr_rd3: in std_logic;
  rdata3: out std_logic_vector(31 downto 0);
  wdata3: in std_logic_vector(31 downto 0);
  size3: in std_logic_vector(1 downto 0);
  eg_datain: in std_logic_vector(7 downto 0);
  eg_ad_dataout: out std_logic_vector(7 downto 0);
  eg_valid: out std_logic;
  eg_ready: in std_logic
);
end top;

architecture rtl of top is

component bridge is
  port (
    clk, rstN: in std_logic;         -- Clock and reset (active low)
    -- Internal bridge to eg interface
    int_datavalid: out std_logic;
    int_datardy: in std_logic;
    int2eg_data: out std_logic_vector(7 downto 0);
    eg2int_data: in std_logic_vector(7 downto 0);
    -- Ingress interface
    int_size: in std_logic_vector(1 downto 0);
    int2ig_data: out std_logic_vector(31 downto 0);
    int_addr_data: in std_logic_vector(38 downto 0);
    int_read_write: in std_logic;
    int_ready: out std_logic;
    int_valid: in std_logic;
    new_tran: out std_logic;
    int_read_done: out std_logic;
    trans_started: in std_logic;
    current_read_write: in std_logic;
    rd_ready: out std_logic
  );
end component;

component ingress is
  port  (
    clk: in std_logic;
    rstN: in std_logic;
    -- Ingress interface
    rd_ready: in std_logic;
    wr_rd: in std_logic;
    valid: in std_logic;
    size: in std_logic_vector(1 downto 0);
    addr: in std_logic_vector(6 downto 0);
    wdata: in std_logic_vector(31 downto 0);
    ready: out std_logic;
    rdata: out std_logic_vector(31 downto 0);
    -- Internal interface
    int_ready: in std_logic;
    int2ig_data: in std_logic_vector(31 downto 0);
    new_tran: in std_logic;
    int_read_done: in std_logic;
    int_read_write: out std_logic;
    int_valid: out std_logic;
    trans_started: out std_logic;
    current_read_write: out std_logic;
    int_size: out std_logic_vector(1 downto 0);
    int_addr_data: out std_logic_vector(38 downto 0)
  );
end component;

component egress is
  port  (
    clk: in std_logic;
    rstN: in std_logic;

    int_datavalid: in std_logic;
    int2eg_data: in std_logic_vector (7 downto 0);
    int_datardy: out std_logic;
    eg2int_data: out std_logic_vector (7 downto 0);

    eg_ready: in std_logic;
    eg_datain: in std_logic_vector (7 downto 0);
    eg_valid: out std_logic;
    eg_ad_dataout: out std_logic_vector (7 downto 0)
  );
end component;

component arbiter is
  port (
    clk, rstN: in std_logic;         -- Clock and reset (active low)

    int_ready: in std_logic;
    int_valid: in std_logic;
    trans_started: in std_logic;
    ig_req: in std_logic_vector (3 downto 0);

    ig_sel: out std_logic_vector (1 downto 0)
  );
end component;

component port_select is
  port (
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
end component;

  signal trans_started0: std_logic;
  signal trans_started1: std_logic;
  signal trans_started2: std_logic;
  signal trans_started3: std_logic;
  signal trans_started: std_logic;

  signal new_tran0: std_logic;
  signal new_tran1: std_logic;
  signal new_tran2: std_logic;
  signal new_tran3: std_logic;
  signal new_tran: std_logic;

  signal int_valid0: std_logic;
  signal int_valid1: std_logic;
  signal int_valid2: std_logic;
  signal int_valid3: std_logic;
  signal int_valid: std_logic;

  signal int_ready0: std_logic;
  signal int_ready1: std_logic;
  signal int_ready2: std_logic;
  signal int_ready3: std_logic;
  signal int_ready: std_logic;

  signal int_read_done0: std_logic;
  signal int_read_done1: std_logic;
  signal int_read_done2: std_logic;
  signal int_read_done3: std_logic;
  signal int_read_done: std_logic;

  signal int_read_write0: std_logic;
  signal int_read_write1: std_logic;
  signal int_read_write2: std_logic;
  signal int_read_write3: std_logic;
  signal int_read_write: std_logic;

  signal current_read_write0: std_logic;
  signal current_read_write1: std_logic;
  signal current_read_write2: std_logic;
  signal current_read_write3: std_logic;
  signal current_read_write: std_logic;

  signal int_size0: std_logic_vector(1 downto 0);
  signal int_size1: std_logic_vector(1 downto 0);
  signal int_size2: std_logic_vector(1 downto 0);
  signal int_size3: std_logic_vector(1 downto 0);
  signal int_size: std_logic_vector(1 downto 0);

  signal int2ig_data0: std_logic_vector(31 downto 0);
  signal int2ig_data1: std_logic_vector(31 downto 0);
  signal int2ig_data2: std_logic_vector(31 downto 0);
  signal int2ig_data3: std_logic_vector(31 downto 0);
  signal int2ig_data: std_logic_vector(31 downto 0);

  signal int_addr_data0: std_logic_vector(38 downto 0);
  signal int_addr_data1: std_logic_vector(38 downto 0);
  signal int_addr_data2: std_logic_vector(38 downto 0);
  signal int_addr_data3: std_logic_vector(38 downto 0);
  signal int_addr_data: std_logic_vector(38 downto 0);

  signal int_datavalid: std_logic;
  signal int_datardy: std_logic;
  signal int2eg_data: std_logic_vector(7 downto 0);
  signal eg2int_data: std_logic_vector(7 downto 0);
  signal ig_sel: std_logic_vector(1 downto 0);
  signal ig_req: std_logic_vector(3 downto 0);
  signal rd_ready: std_logic;

begin

  ing0: ingress port map
  (
    clk => clk,
    rstN => rstN,
    rd_ready => rd_ready,
    addr => addr0,
    valid => valid0,
    ready => ready0,
    wr_rd => wr_rd0,
    rdata => rdata0,
    wdata => wdata0,
    size => size0,
    int_size => int_size0,
    int2ig_data => int2ig_data0,
    int_addr_data => int_addr_data0,
    new_tran => new_tran0,
    int_read_done => int_read_done0,
    current_read_write => current_read_write0,
    int_read_write => int_read_write0,
    int_ready => int_ready0,
    int_valid => int_valid0,
    trans_started => trans_started0
  );

  ing1: ingress port map
  (
    clk => clk,
    rstN => rstN,
    rd_ready => rd_ready,
    addr => addr1,
    valid => valid1,
    ready => ready1,
    wr_rd => wr_rd1,
    rdata => rdata1,
    wdata => wdata1,
    size => size1,
    int_size => int_size1,
    int2ig_data => int2ig_data1,
    int_addr_data => int_addr_data1,
    new_tran => new_tran1,
    int_read_done => int_read_done1,
    current_read_write => current_read_write1,
    int_read_write => int_read_write1,
    int_ready => int_ready1,
    int_valid => int_valid1,
    trans_started => trans_started1
  );

  ing2: ingress port map
  (
    clk => clk,
    rstN => rstN,
    rd_ready => rd_ready,
    addr => addr2,
    valid => valid2,
    ready => ready2,
    wr_rd => wr_rd2,
    rdata => rdata2,
    wdata => wdata2,
    size => size2,
    int_size => int_size2,
    int2ig_data => int2ig_data2,
    int_addr_data => int_addr_data2,
    new_tran => new_tran2,
    int_read_done => int_read_done2,
    current_read_write => current_read_write2,
    int_read_write => int_read_write2,
    int_ready => int_ready2,
    int_valid => int_valid2,
    trans_started => trans_started2
  );

  ing3: ingress port map
  (
    clk => clk,
    rstN => rstN,
    rd_ready => rd_ready,
    addr => addr3,
    valid => valid3,
    ready => ready3,
    wr_rd => wr_rd3,
    rdata => rdata3,
    wdata => wdata3,
    size => size3,
    int_size => int_size3,
    int2ig_data => int2ig_data3,
    int_addr_data => int_addr_data3,
    new_tran => new_tran3,
    int_read_done => int_read_done3,
    current_read_write => current_read_write3,
    int_read_write => int_read_write3,
    int_ready => int_ready3,
    int_valid => int_valid3,
    trans_started => trans_started3
  );

  eg: egress port map
  (
    clk => clk,
    rstN => rstN,
    int2eg_data => int2eg_data,
    eg2int_data => eg2int_data,
    int_datavalid => int_datavalid,
    int_datardy => int_datardy,
    eg_datain => eg_datain,
    eg_ad_dataout => eg_ad_dataout,
    eg_valid => eg_valid,
    eg_ready => eg_ready
  );

  brdg: bridge port map
  (
    clk => clk,
    rstN => rstN,
    int_datavalid => int_datavalid,
    int_datardy => int_datardy,
    int2eg_data => int2eg_data,
    eg2int_data => eg2int_data,
    int_size => int_size,
    int2ig_data => int2ig_data,
    int_addr_data => int_addr_data,
    int_read_write => int_read_write,
    int_ready => int_ready,
    int_valid => int_valid,
    new_tran => new_tran,
    int_read_done => int_read_done,
    trans_started => trans_started,
    current_read_write =>  current_read_write,
    rd_ready => rd_ready
  );

  ig_req <= (valid3 & valid2 & valid1 & valid0);

  arb: arbiter port map
  (
    clk => clk,
    rstN => rstN,
    int_ready => int_ready,
    int_valid => int_valid,
    trans_started => trans_started,
    ig_req => ig_req,
    ig_sel => ig_sel
  );

  p_sel: port_select port map
  (
    ig_sel => ig_sel,
    int_read_write0 => int_read_write0,
    int_read_write1 => int_read_write1,
    int_read_write2 => int_read_write2,
    int_read_write3 => int_read_write3,
    int_read_write => int_read_write,
    int_ready0 => int_ready0,
    int_ready1 => int_ready1,
    int_ready2 => int_ready2,
    int_ready3 => int_ready3,
    int_ready => int_ready,
    int2ig_data0 => int2ig_data0,
    int2ig_data1 => int2ig_data1,
    int2ig_data2 => int2ig_data2,
    int2ig_data3 => int2ig_data3,
    int2ig_data => int2ig_data,
    new_tran0 => new_tran0,
    new_tran1 => new_tran1,
    new_tran2 => new_tran2,
    new_tran3 => new_tran3,
    new_tran => new_tran,
    int_read_done0 => int_read_done0,
    int_read_done1 => int_read_done1,
    int_read_done2 => int_read_done2,
    int_read_done3 => int_read_done3,
    int_read_done => int_read_done,
    int_size0 => int_size0,
    int_size1 => int_size1,
    int_size2 => int_size2,
    int_size3 => int_size3,
    int_size => int_size,
    int_valid0 => int_valid0,
    int_valid1 => int_valid1,
    int_valid2 => int_valid2,
    int_valid3 => int_valid3,
    int_valid => int_valid,
    trans_started0 => trans_started0,
    trans_started1 => trans_started1,
    trans_started2 => trans_started2,
    trans_started3 => trans_started3,
    trans_started => trans_started,
    current_read_write0 => current_read_write0,
    current_read_write1 => current_read_write1,
    current_read_write2 => current_read_write2,
    current_read_write3 => current_read_write3,
    current_read_write => current_read_write,
    int_addr_data0 => int_addr_data0,
    int_addr_data1 => int_addr_data1,
    int_addr_data2 => int_addr_data2,
    int_addr_data3 => int_addr_data3,
    int_addr_data => int_addr_data
  );

end rtl;
