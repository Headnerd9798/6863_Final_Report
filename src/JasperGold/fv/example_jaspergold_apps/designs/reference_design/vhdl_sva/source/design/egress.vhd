-------------------------------------------------------------------------------
--                                                                           --
--  Module:  egress                                                          --
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

entity egress is
  port	(
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
end egress;

architecture rtl of egress is

  type statetype is (EG_IDLE, EG_ADDR, EG_DATA);

  signal nxt_state: statetype;
  signal cur_state: statetype;

  signal read_write: std_logic;
  signal i2c2int_data: std_logic_vector(7 downto 0);

begin

  eg_valid <= '1' when (cur_state /= EG_IDLE) else '0';

  process (clk,rstN) begin
    if rising_edge(clk) then
      if rstN = '0' then
        read_write <= '0';
      else
        if (nxt_state = EG_ADDR) then
          read_write <= int2eg_data(7);
        end if;
      end if;
    end if;
  end process;

  process (clk,rstN) begin
    if rising_edge(clk) then
      if rstN = '0' then
        eg2int_data <= (others => '0');
      else
        if ((read_write = '1') and (cur_state = EG_DATA)) then
          eg2int_data <= eg_datain;
        end if;
      end if;
    end if;
  end process;

  process (clk,rstN) begin
    if rising_edge(clk) then
      if rstN = '0' then
        cur_state <= EG_IDLE;
      else
        cur_state <= nxt_state;
      end if;
    end if;
  end process;

  process (cur_state, int_datavalid, eg_ready) begin
    case (cur_state) is
      when EG_IDLE =>
        if (int_datavalid='1' and eg_ready='1') then
          nxt_state <= EG_ADDR;
        else
          nxt_state <= EG_IDLE;
        end if;
      when EG_ADDR =>
        if (eg_ready = '1') then
          nxt_state <= EG_DATA;
        else
          nxt_state <= EG_ADDR;
        end if;
      when EG_DATA =>
        if (eg_ready = '1') then
          if (int_datavalid='1') then
            nxt_state <= EG_ADDR;
          else
            nxt_state <= EG_IDLE;
          end if;
        else
          nxt_state <= EG_DATA;
        end if;
      when others =>
          nxt_state <= EG_IDLE;
    end case;
  end process;

  process (clk,rstN) begin
    if rising_edge(clk) then
      if (eg_ready='1') then
        eg_ad_dataout <= int2eg_data;
      end if;
    end if;
  end process;

  int_datardy <= '1' when (eg_ready = '1')
                     else '0';

end rtl;
