-------------------------------------------------------------------------------
--                                                                           --
--  Module:  ingress                                                         --
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

entity ingress is
  port	(
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
end ingress;

architecture rtl of ingress is

  signal wr_rd_reg: std_logic;

  signal valid_read: std_logic;

  signal ready_tmp: std_logic;
  signal trans_started_tmp: std_logic;

  signal int_addr: std_logic_vector (6 downto 0);
  signal int_size_tmp: std_logic_vector (1 downto 0);
  signal wdata_reorder: std_logic_vector (31 downto 0);

begin

  process (clk,rstN) begin
    if rising_edge(clk) then
      if rstN = '0' then
        wr_rd_reg <= '1';
      else
        if (valid='1' and ready_tmp='1') then
          wr_rd_reg <= wr_rd;
        end if;
      end if;
    end if;
  end process;

  current_read_write <= '1' when (wr_rd_reg = '0') else '0';

  process (clk,rstN) begin
    if rising_edge(clk) then
      if rstN = '0' then
        valid_read <= '1';
      else
        if ((valid = '1') and (wr_rd = '0')) then
          valid_read <= '0';
        elsif (int_read_done = '1') then
          valid_read <= '1';
        end if;
      end if;
    end if;
  end process;

  ready_tmp <= int_ready when (wr_rd_reg = '1') else valid_read;
  ready <= ready_tmp;

  process (clk) begin
    if rising_edge(clk) then
      if (size = "00") then
        case (addr(1 downto 0)) is
          when "00" =>
            wdata_reorder(7 downto 0)  <= wdata(7 downto 0);
          when "01" =>
            wdata_reorder(7 downto 0)  <= wdata(15 downto 8);
          when "10" =>
            wdata_reorder(7 downto 0)  <= wdata(23 downto 16);
          when "11" =>
            wdata_reorder(7 downto 0)  <= wdata(31 downto 24);
          when others => null;
        end case;
      elsif (size = "01") then
        case (addr(1 downto 0)) is
          when "00" =>
            wdata_reorder(15 downto 0)  <= wdata(15 downto 0);
          when "01" =>
            wdata_reorder(15 downto 0)  <= wdata(23 downto 8);
          when "10" =>
            wdata_reorder(15 downto 0)  <= wdata(31 downto 16);
          when others =>
            wdata_reorder <= wdata;
        end case;
      else
        wdata_reorder <= wdata;
      end if;
    end if;
  end process;

  int_addr_data <= int_addr & wdata_reorder;
  int_size <= int_size_tmp;

  process (clk,rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        trans_started_tmp <= '0';
      else
        if (new_tran='1') then
          trans_started_tmp <= '1';
        elsif (valid='0') then
          trans_started_tmp <= '0';
        end if;
      end if;
    end if;
  end process;

  trans_started <= trans_started_tmp;

  process (clk,rstN) begin
    if rising_edge(clk) then
      if rstN = '0' then
        int_read_write <= '0';
      else
        if (new_tran='1' and trans_started_tmp='1' and wr_rd_reg='0'
          and rd_ready='1') then
          int_read_write <= '1';
        elsif (ready_tmp='1' and trans_started_tmp='1') then
          int_read_write <= '0';
        end if;
      end if;
    end if;
  end process;

  process (clk,rstN) begin
    if rising_edge(clk) then
      if rstN = '0' then
        int_valid <= '0';
        int_addr <= (others => '0');
        int_size_tmp <= (others => '0');
      else
        if (ready_tmp='1' and valid='1') then
          int_valid <= '1';
          int_addr <= addr;
          if    (size = "00") then int_size_tmp <= "01";
          elsif (size = "01") then int_size_tmp <= "10";
          elsif (size = "10") then int_size_tmp <= "00";
          end if;
        else
          int_valid <= '0';
        end if;
      end if;
    end if;
  end process;

  rdata <= int2ig_data;

end rtl;
