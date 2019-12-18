-------------------------------------------------------------------------------
--                                                                           --
--  Module:  bridge                                                          --
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

entity bridge is
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
end bridge;

architecture rtl of bridge is

  type MEM is array (0 to 15) of std_logic_vector(40 downto 0);
  signal fifo: MEM;
  signal wr_ptr: std_logic_vector(3 downto 0);
  signal rd_ptr: std_logic_vector(3 downto 0);
  signal fifo_full: std_logic;
  signal fifo_empty: std_logic;

  type MEM_AD is array (0 to 15) of std_logic_vector(6 downto 0);
  signal fifo_addr: MEM_AD;
  signal fifo_out: std_logic_vector(40 downto 0);
  signal fifo0:  std_logic_vector(40 downto 0);
  signal fifo1:  std_logic_vector(40 downto 0);
  signal fifo2:  std_logic_vector(40 downto 0);
  signal fifo3:  std_logic_vector(40 downto 0);
  signal fifo4:  std_logic_vector(40 downto 0);
  signal fifo5:  std_logic_vector(40 downto 0);
  signal fifo6:  std_logic_vector(40 downto 0);
  signal fifo7:  std_logic_vector(40 downto 0);
  signal fifo8:  std_logic_vector(40 downto 0);
  signal fifo9:  std_logic_vector(40 downto 0);
  signal fifo10: std_logic_vector(40 downto 0);
  signal fifo11: std_logic_vector(40 downto 0);
  signal fifo12: std_logic_vector(40 downto 0);
  signal fifo13: std_logic_vector(40 downto 0);
  signal fifo14: std_logic_vector(40 downto 0);
  signal fifo15: std_logic_vector(40 downto 0);
  signal wr_ptr_minus1: std_logic_vector(3 downto 0);
  signal fifo_entry_valid: std_logic_vector (15 downto 0);

  signal read_dep: std_logic;
  signal out_size: std_logic_vector(1 downto 0);
  signal byte_num: std_logic_vector(1 downto 0);
  signal last_byte_num: std_logic;
  signal read_addr: std_logic_vector(6 downto 0);
  signal new_addr: std_logic_vector(6 downto 0);
  signal new_addr_dep: std_logic_vector(6 downto 0);
  signal new_addr_dep_ne_0: std_logic;
  signal addr_fifo: std_logic;

  signal int2eg_end: std_logic;
  signal int_ready_tmp: std_logic;
  signal int_datavalid_tmp2: std_logic;

  signal int_datavalid_tmp: std_logic;

begin

  fifo_out   <= fifo(conv_integer(rd_ptr));
  fifo_full  <= '1' when (wr_ptr = (rd_ptr - 1)) else '0';
  fifo_empty <= '1' when (wr_ptr = rd_ptr) else '0';

  int_ready_tmp <= '1' when ((read_dep='0' or int_read_write='0')
                         and fifo_full='0')
                       else '0';
  int_ready <= int_ready_tmp;

  int_datavalid_tmp2 <= '1' when (int_datavalid_tmp='1' and fifo_empty='0')
                            else '0';
  int_datavalid <= int_datavalid_tmp2;

  out_size <= fifo_out(1 downto 0) when (int_read_write='0')
                                   else "00";

  new_tran <= '1' when (fifo_empty='1'
                    or (int2eg_end='1' and int_datardy='1'))
                  else '0';

  int_read_done <= '1' when (int2eg_end='1' and int_datardy='1'
                         and int_read_write='1')
                       else '0';

  last_byte_num <= '1' when (((out_size="00") and (byte_num="11"))
                         or ((out_size="01") and (byte_num="00"))
                         or ((out_size="10") and (byte_num="01"))
                         or ((out_size="11") and (byte_num="10")))
                       else '0';

  int2eg_end <= '1' when (int_datavalid_tmp2='1' and last_byte_num='1'
                        and addr_fifo='0')
                      else '0';

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        addr_fifo <= '1';
      else
        if (int_datavalid_tmp2='1' and int_datardy='1'
          and int_ready_tmp='1') then
          addr_fifo <= not addr_fifo;
        end if;
      end if;
    end if;
  end process;

  process (addr_fifo, read_dep, read_addr, int_read_write, fifo_out,
    byte_num) begin
    if (int_read_write='1' and read_dep='0') then
      case byte_num is
        when "00" => int2eg_data <= '1' & read_addr;
        when "01" => int2eg_data <= '1' & (read_addr + 1);
        when "10" => int2eg_data <= '1' & (read_addr + 2);
        when "11" => int2eg_data <= '1' & (read_addr + 3);
        when others => null;
      end case;
    else
      case byte_num is
        when "00" =>
          if (addr_fifo='1') then
            int2eg_data <= '0' & fifo_out(40 downto 34);
          else
            int2eg_data <= fifo_out(9 downto 2);
          end if;
        when "01" =>
          if (addr_fifo='1') then
            int2eg_data <= '0' & (fifo_out(40 downto 34) + 1);
          else
            int2eg_data <= fifo_out(17 downto 10);
          end if;
        when "10" =>
          if (addr_fifo='1') then
            int2eg_data <= '0' & (fifo_out(40 downto 34) + 2);
          else
            int2eg_data <= fifo_out(25 downto 18);
          end if;
        when "11" =>
          if (addr_fifo='1') then
            int2eg_data <= '0' & (fifo_out(40 downto 34) + 3);
          else
            int2eg_data <= fifo_out(33 downto 26);
          end if;
        when others => null;
      end case;
    end if;
  end process;

  fifo0  <= fifo(0);
  fifo1  <= fifo(1);
  fifo2  <= fifo(2);
  fifo3  <= fifo(3);
  fifo4  <= fifo(4);
  fifo5  <= fifo(5);
  fifo6  <= fifo(6);
  fifo7  <= fifo(7);
  fifo8  <= fifo(8);
  fifo9  <= fifo(9);
  fifo10 <= fifo(10);
  fifo11 <= fifo(11);
  fifo12 <= fifo(12);
  fifo13 <= fifo(13);
  fifo14 <= fifo(14);
  fifo15 <= fifo(15);

  fifo_addr(0)  <= fifo0(40 downto 34);
  fifo_addr(1)  <= fifo1(40 downto 34);
  fifo_addr(2)  <= fifo2(40 downto 34);
  fifo_addr(3)  <= fifo3(40 downto 34);
  fifo_addr(4)  <= fifo4(40 downto 34);
  fifo_addr(5)  <= fifo5(40 downto 34);
  fifo_addr(6)  <= fifo6(40 downto 34);
  fifo_addr(7)  <= fifo7(40 downto 34);
  fifo_addr(8)  <= fifo8(40 downto 34);
  fifo_addr(9)  <= fifo9(40 downto 34);
  fifo_addr(10) <= fifo10(40 downto 34);
  fifo_addr(11) <= fifo11(40 downto 34);
  fifo_addr(12) <= fifo12(40 downto 34);
  fifo_addr(13) <= fifo13(40 downto 34);
  fifo_addr(14) <= fifo14(40 downto 34);
  fifo_addr(15) <= fifo15(40 downto 34);

  wr_ptr_minus1 <= wr_ptr - 1;

  process (wr_ptr, rd_ptr, wr_ptr_minus1) begin
    if (wr_ptr=rd_ptr) then
      fifo_entry_valid <= (others => '0');
    elsif (wr_ptr_minus1 >= rd_ptr) then
      if ((conv_integer(wr_ptr_minus1)>=0) and (conv_integer(rd_ptr)<=0)) then
        fifo_entry_valid(0) <= '1';
      else
        fifo_entry_valid(0) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=1) and (conv_integer(rd_ptr)<=1)) then
        fifo_entry_valid(1) <= '1';
      else
        fifo_entry_valid(1) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=2) and (conv_integer(rd_ptr)<=2)) then
        fifo_entry_valid(2) <= '1';
      else
        fifo_entry_valid(2) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=3) and (conv_integer(rd_ptr)<=3)) then
        fifo_entry_valid(3) <= '1';
      else
        fifo_entry_valid(3) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=4) and (conv_integer(rd_ptr)<=4)) then
        fifo_entry_valid(4) <= '1';
      else
        fifo_entry_valid(4) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=5) and (conv_integer(rd_ptr)<=5)) then
        fifo_entry_valid(5) <= '1';
      else
        fifo_entry_valid(5) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=6) and (conv_integer(rd_ptr)<=6)) then
        fifo_entry_valid(6) <= '1';
      else
        fifo_entry_valid(6) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=7) and (conv_integer(rd_ptr)<=7)) then
        fifo_entry_valid(7) <= '1';
      else
        fifo_entry_valid(7) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=8) and (conv_integer(rd_ptr)<=8)) then
        fifo_entry_valid(8) <= '1';
      else
        fifo_entry_valid(8) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=9) and (conv_integer(rd_ptr)<=9)) then
        fifo_entry_valid(9) <= '1';
      else
        fifo_entry_valid(9) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=10) and (conv_integer(rd_ptr)<=10)) then
        fifo_entry_valid(10) <= '1';
      else
        fifo_entry_valid(10) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=11) and (conv_integer(rd_ptr)<=11)) then
        fifo_entry_valid(11) <= '1';
      else
        fifo_entry_valid(11) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=12) and (conv_integer(rd_ptr)<=12)) then
        fifo_entry_valid(12) <= '1';
      else
        fifo_entry_valid(12) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=13) and (conv_integer(rd_ptr)<=13)) then
        fifo_entry_valid(13) <= '1';
      else
        fifo_entry_valid(13) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=14) and (conv_integer(rd_ptr)<=14)) then
        fifo_entry_valid(14) <= '1';
      else
        fifo_entry_valid(14) <= '0';
      end if;
      if ((conv_integer(wr_ptr_minus1)>=15) and (conv_integer(rd_ptr)<=15)) then
        fifo_entry_valid(15) <= '1';
      else
        fifo_entry_valid(15) <= '0';
      end if;
    else
      if ((conv_integer(wr_ptr) > 0) or (conv_integer(rd_ptr) <= 0)) then
        fifo_entry_valid(0) <= '1';
      else
        fifo_entry_valid(0) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 1) or (conv_integer(rd_ptr) <= 1)) then
        fifo_entry_valid(1) <= '1';
      else
        fifo_entry_valid(1) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 2) or (conv_integer(rd_ptr) <= 2)) then
        fifo_entry_valid(2) <= '1';
      else
        fifo_entry_valid(2) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 3) or (conv_integer(rd_ptr) <= 3)) then
        fifo_entry_valid(3) <= '1';
      else
        fifo_entry_valid(3) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 4) or (conv_integer(rd_ptr) <= 4)) then
        fifo_entry_valid(4) <= '1';
      else
        fifo_entry_valid(4) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 5) or (conv_integer(rd_ptr) <= 5)) then
        fifo_entry_valid(5) <= '1';
      else
        fifo_entry_valid(5) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 6) or (conv_integer(rd_ptr) <= 6)) then
        fifo_entry_valid(6) <= '1';
      else
        fifo_entry_valid(6) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 7) or (conv_integer(rd_ptr) <= 7)) then
        fifo_entry_valid(7) <= '1';
      else
        fifo_entry_valid(7) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 8) or (conv_integer(rd_ptr) <= 8)) then
        fifo_entry_valid(8) <= '1';
      else
        fifo_entry_valid(8) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 9) or (conv_integer(rd_ptr) <= 9)) then
        fifo_entry_valid(9) <= '1';
      else
        fifo_entry_valid(9) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 10) or (conv_integer(rd_ptr) <= 10)) then
        fifo_entry_valid(10) <= '1';
      else
        fifo_entry_valid(10) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 11) or (conv_integer(rd_ptr) <= 11)) then
        fifo_entry_valid(11) <= '1';
      else
        fifo_entry_valid(11) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 12) or (conv_integer(rd_ptr) <= 12)) then
        fifo_entry_valid(12) <= '1';
      else
        fifo_entry_valid(12) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 13) or (conv_integer(rd_ptr) <= 13)) then
        fifo_entry_valid(13) <= '1';
      else
        fifo_entry_valid(13) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 14) or (conv_integer(rd_ptr) <= 14)) then
        fifo_entry_valid(14) <= '1';
      else
        fifo_entry_valid(14) <= '0';
      end if;
      if ((conv_integer(wr_ptr) > 15) or (conv_integer(rd_ptr) <= 15)) then
        fifo_entry_valid(15) <= '1';
      else
        fifo_entry_valid(15) <= '0';
      end if;
    end if;
  end process;

  new_addr <= int_addr_data(38 downto 32);

  new_addr_dep(0) <= '1' when (fifo_entry_valid(0)='1'
                           and ((new_addr>=fifo_addr(0))
                             or (new_addr+7<=(fifo_addr(0)+7))
                             or ((new_addr+7>(fifo_addr(0)+7))
                               and (new_addr<fifo_addr(0)))))
                         else '0';
  new_addr_dep(1) <= '1' when (fifo_entry_valid(1)='1'
                           and ((new_addr>=fifo_addr(1))
                             or (new_addr+7<=(fifo_addr(1)+7))
                             or ((new_addr+7>(fifo_addr(1)+7))
                               and (new_addr<fifo_addr(1)))))
                         else '0';
  new_addr_dep(2) <= '1' when (fifo_entry_valid(2)='1'
                           and ((new_addr>=fifo_addr(2))
                             or (new_addr+7<=(fifo_addr(2)+7))
                             or ((new_addr+7>(fifo_addr(2)+7))
                               and (new_addr<fifo_addr(2)))))
                         else '0';
  new_addr_dep(3) <= '1' when (fifo_entry_valid(3)='1'
                           and ((new_addr>=fifo_addr(3))
                             or (new_addr+7<=(fifo_addr(3)+7))
                             or ((new_addr+7>(fifo_addr(3)+7))
                               and (new_addr<fifo_addr(3)))))
                         else '0';
  new_addr_dep(4) <= '1' when (fifo_entry_valid(4)='1'
                           and ((new_addr>=fifo_addr(4))
                             or (new_addr+7<=(fifo_addr(4)+7))
                             or ((new_addr+7>(fifo_addr(4)+7))
                               and (new_addr<fifo_addr(4)))))
                         else '0';
  new_addr_dep(5) <= '1' when (fifo_entry_valid(5)='1'
                           and ((new_addr>=fifo_addr(5))
                             or (new_addr+7<=(fifo_addr(5)+7))
                             or ((new_addr+7>(fifo_addr(5)+7))
                               and (new_addr<fifo_addr(5)))))
                         else '0';
  new_addr_dep(6) <= '1' when (fifo_entry_valid(6)='1'
                           and ((new_addr>=fifo_addr(6))
                             or (new_addr+7<=(fifo_addr(6)+7))
                             or ((new_addr+7>(fifo_addr(6)+7))
                               and (new_addr<fifo_addr(6)))))
                         else '0';

  read_dep <= '1' when (new_addr_dep/="0000000000000000") else '0';
  rd_ready <= not read_dep;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        read_addr <= (others => '0');
      else
        if (int_datavalid_tmp2='1' and int_read_write='1') then
          read_addr <= int_addr_data(38 downto 32);
        end if;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        int_datavalid_tmp <= '0';
      else
        if (int_ready_tmp='1' and (int_read_write='1' or fifo_empty='0')) then
          int_datavalid_tmp <= '1';
        elsif (int_read_write='0' and fifo_empty='1') then
          int_datavalid_tmp <= '0';
        elsif (int_read_write='1' and trans_started='1') then
          int_datavalid_tmp <= '0';
        end if;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        fifo(0)  <= (others => '0');
        fifo(1)  <= (others => '0');
        fifo(2)  <= (others => '0');
        fifo(3)  <= (others => '0');
        fifo(4)  <= (others => '0');
        fifo(5)  <= (others => '0');
        fifo(6)  <= (others => '0');
        fifo(7)  <= (others => '0');
        fifo(8)  <= (others => '0');
        fifo(9)  <= (others => '0');
        fifo(10) <= (others => '0');
        fifo(11) <= (others => '0');
        fifo(12) <= (others => '0');
        fifo(13) <= (others => '0');
        fifo(14) <= (others => '0');
        fifo(15) <= (others => '0');
      else
        if (int_valid='1' and int_read_write='0') then
          fifo(conv_integer(wr_ptr)) <= int_addr_data & int_size;
        end if;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        wr_ptr <= (others => '0');
        rd_ptr <= (others => '0');
      else
        if (int_valid='1' and int_ready_tmp='1' and current_read_write='0') then
          wr_ptr <= wr_ptr + 1;
        end if;
        if (int_datavalid_tmp2='1' and int_datardy='1' and int2eg_end='1'
          and (read_dep='1' or int_read_write='0')) then
          rd_ptr <= rd_ptr + 1;
        end if;
      end if;
    end if;
  end process;

  process (clk, rstN) begin
    if rising_edge(clk) then
      if rstN='0' then
        byte_num <= (others => '0');
      else
        if (addr_fifo='0' and int_datardy='1' and out_size/="01"
          and byte_num="00") then
          byte_num <= "01";
        elsif (addr_fifo='0' and int_datavalid_tmp2='1'
          and int_datardy='1') then
          if (out_size/="10" and byte_num="01") then
            byte_num <= "10";
          elsif (out_size/="11" and byte_num="10") then
            byte_num <= "11";
          else
            byte_num <= "00";
          end if;
        end if;
      end if;
    end if;
  end process;

end rtl;
