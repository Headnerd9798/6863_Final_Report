-------------------------------------------------------------------------------
--                                                                           --
--  Module:  arbiter                                                         --
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity arbiter is
  port (
    clk, rstN: in std_logic;         -- Clock and reset (active low)

    int_ready: in std_logic;
    int_valid: in std_logic;
    trans_started: in std_logic;
    ig_req: in std_logic_vector (3 downto 0);

    ig_sel: out std_logic_vector (1 downto 0)
  );
end arbiter;

architecture rtl of arbiter is

  -- when the arbiter is ready to sample the next request
  signal sample_transfer_ready: std_logic;

  -- Generated sample timer counter
  signal sample_timer_cnt: std_logic_vector (1 downto 0);
  -- Sampling signals based on sampling counter
  signal sample_hipri: std_logic;
  signal sample_pgrant: std_logic;
  signal sample_grant: std_logic;
  signal sample_ready: std_logic;

  -- Enable for round-robin shift register
  signal last_phase: std_logic;

  -- Internal request until grant
  signal req: std_logic_vector (3 downto 0);
  -- Sampled request until grant
  signal req_r: std_logic_vector (3 downto 0);

  -- Counters to increase priority when duration since the last transfer
  -- from respective port reaches HI_PRI_CNT limit
  signal port_idle_cnt0: std_logic_vector (8 downto 0);
  signal port_idle_cnt1: std_logic_vector (8 downto 0);
  signal port_idle_cnt2: std_logic_vector (8 downto 0);
  signal port_idle_cnt3: std_logic_vector (8 downto 0);

  -- High priority level
  signal hi_pri: std_logic_vector (3 downto 0);

  -- Determine round-robin port
  signal shift: std_logic_vector (3 downto 0);
  -- Delayed version of shift
  signal shift_d: std_logic_vector (3 downto 0);

  -- Current port for grant
  signal current_port: std_logic_vector (1 downto 0);
  -- Next port for grant
  signal next_port: std_logic_vector (1 downto 0);

  -- Req based on port idle priority
  signal pri_req: std_logic_vector (3 downto 0);

  -- Round-robin priority of each port
  signal sel0: std_logic_vector (1 downto 0);
  signal sel1: std_logic_vector (1 downto 0);
  signal sel2: std_logic_vector (1 downto 0);
  signal sel3: std_logic_vector (1 downto 0);

  -- Output of the round-robin port selector
  signal req_rr: std_logic_vector (3 downto 0);
  -- Delayed version of req_rr
  signal req_rr_d: std_logic_vector (3 downto 0);

  -- Generate grant
  signal gnt: std_logic_vector (3 downto 0);

  signal hipri_req: std_logic;
  signal rr_shift: std_logic_vector (3 downto 0);

begin

  req <= ig_req;

  sample_transfer_ready <= '1' when (sample_ready='1' and last_phase='0'
                                 and req/="0000" and trans_started='0'
                                 and int_valid='0')
                               else '0';

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        sample_timer_cnt <= "11";
      else
        if (sample_transfer_ready='1') then
          sample_timer_cnt <= "00";
        elsif (sample_ready='0' and sample_pgrant='0') then
          sample_timer_cnt <= sample_timer_cnt + "01";
        elsif (sample_pgrant='1' and int_ready='1') then
          sample_timer_cnt <= sample_timer_cnt + "01";
        end if;
      end if;
    end if;
  end process;

  sample_hipri  <= '1' when (sample_timer_cnt="00") -- Check high priority
                       else '0';
  sample_pgrant <= '1' when (sample_timer_cnt="01") -- Cycle before grant
                       else '0';
  sample_grant  <= '1' when (sample_timer_cnt="10") -- Generate grant
                       else '0';
  sample_ready  <= '1' when (sample_timer_cnt="11") -- Grant issued
                       else '0';

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        last_phase <= '0';
      else
        last_phase <= sample_grant;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        req_r <= "0000";
      else
        if (sample_transfer_ready='1') then
          req_r <= req;
        end if;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        port_idle_cnt0 <= "000000000";
        port_idle_cnt1 <= "000000000";
        port_idle_cnt2 <= "000000000";
        port_idle_cnt3 <= "000000000";
        hi_pri <= "0000";
      else
        if (gnt(0)='1') then
          hi_pri(0) <= '0';
          port_idle_cnt0 <= "000000000";
        else
          if (port_idle_cnt0="111110100") then
            hi_pri(0) <= '1';
          end if;
          port_idle_cnt0 <= port_idle_cnt0 + "000000001";
        end if;
        if (gnt(1)='1') then
          hi_pri(1) <= '0';
          port_idle_cnt1 <= "000000000";
        else
          if (port_idle_cnt1="111110100") then
            hi_pri(1) <= '1';
          end if;
          port_idle_cnt1 <= port_idle_cnt1 + "000000001";
        end if;
        if (gnt(2)='1') then
          hi_pri(2) <= '0';
          port_idle_cnt2 <= "000000000";
        else
          if (port_idle_cnt2="111110100") then
            hi_pri(2) <= '1';
          end if;
          port_idle_cnt2 <= port_idle_cnt2 + "000000001";
        end if;
        if (gnt(3)='1') then
            hi_pri(3) <= '0';
          port_idle_cnt3 <= "000000000";
        else
          if (port_idle_cnt3="111110100") then
          hi_pri(3) <= '1';
          end if;
          port_idle_cnt3 <= port_idle_cnt3 + "000000001";
        end if;
      end if;
    end if;
  end process;

  hipri_req <= '1' when ((req_r(0)='1' and hi_pri(0)='1')
                      or (req_r(1)='1' and hi_pri(1)='1')
                      or (req_r(2)='1' and hi_pri(2)='1')
                      or (req_r(3)='1' and hi_pri(3)='1'))
                   else '0';

  pri_req(0) <= '1' when
    (sample_hipri='1' and hipri_req='1' and req_r(0)='1' and hi_pri(0)='1')
    or (sample_hipri='1' and hipri_req='0' and req_r(0)='1')
                    else '0';
  pri_req(1) <= '1' when
    (sample_hipri='1' and hipri_req='1' and req_r(1)='1' and hi_pri(1)='1')
    or (sample_hipri='1' and hipri_req='0' and req_r(1)='1')
                    else '0';
  pri_req(2) <= '1' when
    (sample_hipri='1' and hipri_req='1' and req_r(2)='1' and hi_pri(2)='1')
    or (sample_hipri='1' and hipri_req='0' and req_r(2)='1')
                    else '0';
  pri_req(3) <= '1' when
    (sample_hipri='1' and hipri_req='1' and req_r(3)='1' and hi_pri(3)='1')
    or (sample_hipri='1' and hipri_req='0' and req_r(3)='1')
                    else '0';

  process (sel0, sel1, sel2, sel3, pri_req) begin
    if (pri_req(conv_integer(sel0))='1') then
      req_rr(0) <= '1';
    else
      req_rr(0) <= '0';
    end if;
    if (pri_req(conv_integer(sel1))='1') then
      req_rr(1) <= '1';
    else
      req_rr(1) <= '0';
    end if;
    if (pri_req(conv_integer(sel2))='1') then
      req_rr(2) <= '1';
    else
      req_rr(2) <= '0';
    end if;
    if (pri_req(conv_integer(sel3))='1') then
      req_rr(3) <= '1';
    else
      req_rr(3) <= '0';
    end if;
  end process;

  rr_shift <= shift_d;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        req_rr_d <= "0000";
      else
        req_rr_d <= req_rr;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        current_port <= "00";
      else
        if (last_phase='0') then
          current_port <= next_port;
        end if;
      end if;
    end if;
  end process;

  process (sel0, sel1, sel2, sel3, current_port, req_rr_d) begin
    if    (req_rr_d(0)='1') then
      next_port <= sel0;
    elsif (req_rr_d(1)='1') then
      next_port <= sel1;
    elsif (req_rr_d(2)='1') then
      next_port <= sel2;
    elsif (req_rr_d(3)='1') then
      next_port <= sel3;
    else
      next_port <= current_port;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        shift_d <= "0000";
      else
        if (last_phase='0') then
          shift_d <= shift;
        end if;
      end if;
    end if;
  end process;

  process (shift_d, req_rr_d) begin
    if    (req_rr_d(0)='1') then
      shift <= "1111";
    elsif (req_rr_d(1)='1') then
      shift <= "1110";
    elsif (req_rr_d(2)='1') then
      shift <= "1100";
    elsif (req_rr_d(3)='1') then
      shift <= "1000";
    else
      shift <= shift_d;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        sel0 <= "00";
        sel1 <= "01";
        sel2 <= "10";
        sel3 <= "11";
      else
        if (last_phase='1') then
          if (rr_shift(0)='1') then
            sel0 <= sel1;
          end if;
          if (rr_shift(1)='1') then
            sel1 <= sel2;
          end if;
          if (rr_shift(2)='1') then
            sel2 <= sel3;
          end if;
          if (rr_shift(3)='1') then
            sel3 <= current_port;
          end if;
        end if;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        gnt <= "0000";
      else
        if (sample_grant='1' and next_port="00") then
          gnt(0) <= '1';
        else
          gnt(0) <= '0';
        end if;
        if (sample_grant='1' and next_port="01") then
          gnt(1) <= '1';
        else
          gnt(1) <= '0';
        end if;
        if (sample_grant='1' and next_port="10") then
          gnt(2) <= '1';
        else
          gnt(2) <= '0';
        end if;
        if (sample_grant='1' and next_port="11") then
          gnt(3) <= '1';
        else
          gnt(3) <= '0';
        end if;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        ig_sel <= "00";
      else
        if (sample_grant='1') then
          ig_sel <= next_port;
        end if;
      end if;
    end if;
  end process;

end rtl;
