library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.hash_constants.all;
library lib;
use lib.fifo;
use lib.otp_ram;

entity hash is
  port (
    clk, rst_n: in std_logic;

    s_req, s_write, s_secure: in std_logic;
    s_addr: in std_logic_vector(11 downto 0);
    s_wdata: in std_logic_vector(31 downto 0);
    s_ack, s_err: buffer std_logic;
    s_rdata: buffer std_logic_vector(31 downto 0)
  );
end hash;

architecture rtl of hash is
  signal key_select_load, custom_key_load: std_logic;
  signal key_select: std_logic;
  signal custom_key: std_logic_vector(31 downto 0);

  signal otp_key: std_logic_vector(31 downto 0);
  signal otp_key_valid: std_logic;
  
  signal otp_read_en: std_logic;
  signal otp_read_addr: std_logic_vector(1 downto 0);
  signal otp_read_data: std_logic_vector(7 downto 0);

  signal otp_prog_load: std_logic;
  signal otp_prog_en: std_logic;
  signal otp_prog_addr: std_logic_vector(1 downto 0);
  signal otp_prog_bit: std_logic_vector(2 downto 0);
  signal otp_prog_data: std_logic;

  signal s_rdata_prev: std_logic_vector(31 downto 0);
  signal s_err_prev: std_logic;

  signal key: std_logic_vector(31 downto 0);

  signal hash_busy, hash_out_valid: std_logic;
  signal hash_value_next: std_logic_vector(31 downto 0);

  signal hash_start, hash_active, hash_clear, hash_expected_valid, hash_secure_only, hash_expected_load: std_logic;
  signal hash_expected_value, hash_value: std_logic_vector(31 downto 0);
  signal hash_data_left, hash_data_left_next, hash_proc_left: unsigned(4 downto 0);
  
  signal fifo_pop, fifo_push, fifo_empty, fifo_full: std_logic;
  signal fifo_data_out, fifo_data_in: std_logic_vector(31 downto 0);
  
  signal rst_n_hash_clear: std_logic;
begin

  fifo_pop <= '1' when (fifo_empty = '0' AND hash_busy = '0') else '0';
  fifo_data_in <= s_wdata;

  process (s_req, s_addr, s_write, s_secure, hash_active, hash_expected_valid, hash_secure_only, hash_data_left, fifo_full) begin
    if (FIX1) then
      if ((s_req = '1') AND (s_addr = ADDR_HASH_DATA) AND (s_write = '1') AND
          (hash_active = '1') AND (hash_expected_valid = '1') AND (hash_secure_only = '0' OR s_secure = '1') AND
          (hash_data_left > 0) AND
          (fifo_full = '0')) then
        fifo_push <= '1';
      else
        fifo_push <= '0';
      end if;
    else
      if ((s_req = '1') AND (s_addr = ADDR_HASH_DATA) AND (s_write = '1') AND
          (hash_active = '1') AND (hash_expected_valid = '1') AND (hash_secure_only = '0' OR s_secure = '1') AND
          (hash_data_left > 0)) then
        fifo_push <= '1';
      else
        fifo_push <= '0';
      end if;
   end if;
  end process;
  
  key <= otp_key when (key_select = KEY_SELECT_OTP) else custom_key;

  process (clk, rst_n) begin
    if (rst_n = '0') then
      hash_active <= '0';
      custom_key <= X"00000000";
      key_select <= KEY_SELECT_OTP;
      otp_prog_en <= '0';
    elsif (rising_edge(clk)) then
      if (hash_start = '1') then
        hash_active <= '1';
        hash_secure_only <= s_wdata(8);
        hash_expected_valid <= '0';
        hash_data_left <= unsigned(s_wdata(4 downto 0));
        hash_proc_left <= unsigned(s_wdata(4 downto 0));
        hash_value <= X"00000000";
      end if;
      if (hash_expected_load = '1') then
        hash_expected_valid <= '1';
        hash_expected_value <= s_wdata;
      end if;
      if (hash_clear = '1') then
        hash_active <= '0';
      end if;
      if (custom_key_load = '1') then
        custom_key <= s_wdata;
      end if;
      if (key_select_load = '1') then
        key_select <= s_wdata(0);
      end if;
      if (otp_prog_load = '1') then
        otp_prog_en <= '1';
        otp_prog_addr <= s_wdata(17 downto 16);
        otp_prog_bit <= s_wdata(10 downto 8);
        otp_prog_data <= s_wdata(0);
      else
        otp_prog_en <= '0';
      end if;
      if (fifo_push = '1') then
        hash_data_left <= (hash_data_left - 1);
      end if;
      if (hash_active = '1' AND hash_out_valid = '1') then
        hash_value <= hash_value_next;
        hash_proc_left <= (hash_proc_left - 1);
      end if;
      s_rdata_prev <= s_rdata;
      s_err_prev <= s_err;
    end if;
  end process;
  
  process (s_req, s_addr, s_wdata, s_secure, s_write, s_err_prev, s_rdata_prev,
           key_select, otp_key, otp_key_valid, custom_key,
           hash_active, hash_secure_only, hash_data_left, hash_proc_left, hash_expected_valid, hash_expected_value, hash_value,
           fifo_full
  ) begin
    s_ack <= '0';
    s_err <= s_err_prev;
    s_rdata <= s_rdata_prev;
    hash_start <= '0';
    hash_expected_load <= '0';
    hash_clear <= '0';
    otp_prog_load <= '0';
    custom_key_load <= '0';
    key_select_load <= '0';
    hash_data_left_next <= hash_data_left;
    if (s_req = '1') then
      case (s_addr) is
        when ADDR_HASH_START =>
          if (s_write = '0' OR hash_active = '1' OR (s_wdata(8) = '1' AND s_secure = '0') OR (unsigned(s_wdata(4 downto 0)) = 0) OR (unsigned(s_wdata(4 downto 0)) > 16)) then
            s_ack <= '1';
            s_err <= '1';
          elsif (key_select = KEY_SELECT_CUSTOM OR otp_key_valid = '1') then
            s_ack <= '1';
            s_err <= '0';
            hash_start <= '1';
          end if;
        when ADDR_HASH_EXPECTED =>
          if (hash_active = '0' OR (hash_secure_only = '1' AND s_secure = '0') OR (s_write = '0' AND hash_expected_valid = '0') OR (s_write = '1'AND hash_expected_valid = '1')) then
            s_ack <= '1';
            s_err <= '1';
          else
            if (s_write = '1') then
              hash_expected_load <= '1';
            end if;
            s_rdata <= hash_expected_value;
            s_ack <= '1';
          end if;
        when ADDR_HASH_DATA =>
          if (s_write = '0' OR hash_active = '0' OR hash_expected_valid = '0' OR (hash_secure_only = '1' AND s_secure = '0') OR (hash_data_left = 0)) then
            s_ack <= '1';
            s_err <= '1';
          elsif (fifo_full = '0') then
            hash_data_left_next <= (hash_data_left - 1);
            s_ack <= '1';
            s_err <= '0';
          end if;
        when ADDR_HASH_STATUS =>
          if (s_write = '1' OR hash_active = '0' OR (hash_secure_only = '1' AND s_secure = '0')) then
            s_ack <= '1';
            s_err <= '1';
          else
            s_ack <= '1';
            if (FIX2) then
              s_err <= '0';
            end if;
            if (hash_proc_left = 0) then
              if (hash_value = hash_expected_value) then
                s_rdata <= HASH_STATUS_PASS;
              else
                s_rdata <= HASH_STATUS_FAIL;
              end if;
            else
              s_rdata <= HASH_STATUS_BUSY;
            end if;
          end if;
        when ADDR_HASH_CLEAR =>
          if (s_write = '0' OR hash_active = '0' OR (hash_secure_only = '1' AND s_secure = '0')) then
            s_ack <= '1';
            s_err <= '1';
          else
            s_ack <= '1';
            s_err <= '0';
            hash_clear <= '1';
          end if;
        when ADDR_KEY_SELECT =>
          if (hash_active = '1' OR s_secure = '0') then
            s_ack <= '1';
            s_err <= '1';
          else
            s_ack <= '1';
            s_err <= '0';
            s_rdata <= (0 => key_select, others => '0');
            if (s_write = '1') then
              key_select_load <= '1';
            end if;
          end if;
        when ADDR_CUSTOM_KEY =>
          if (hash_active = '1' OR s_secure = '0') then
            s_ack <= '1';
            s_err <= '1';
          else
            s_ack <= '1';
            s_err <= '0';
            s_rdata <= custom_key;
            if (s_write = '1') then
              custom_key_load <= '1';
            end if;
          end if;
        when ADDR_OTP_PROG =>
          if (s_write = '0' OR hash_active = '1' OR s_secure = '0') then
            s_ack <= '1';
            s_err <= '1';
          else
            otp_prog_load <= '1';
            s_ack <= '1';
            s_err <= '0';
          end if;
        when others =>
          s_ack <= '1';
          s_err <= '1';
      end case;
    end if;
  end process;

  rst_n_hash_clear <= '1' when (rst_n = '1' AND hash_clear = '0') else '0';

  hash_core: entity work.hash_core
    port map (
      clk => clk, rst_n => rst_n_hash_clear,
      key => key,
      in_valid => fifo_pop,
      in_data => fifo_data_out,
      in_prev => hash_value,
      busy => hash_busy,
      out_valid => hash_out_valid,
      out_hash => hash_value_next
    );

  fifo: entity lib.fifo
    generic map (
      PTR_W => 3,
      DATA_W => 32
    )
    port map (
      clk => clk, rst_n => rst_n_hash_clear,
      push => fifo_push,
      data_in => fifo_data_in,
      pop => fifo_pop,
      data_out => fifo_data_out,
      level => OPEN,
      empty => fifo_empty,
      full => fifo_full
    );

  otp_ram: entity lib.otp_ram
    generic map (
      ADDR_W => 2
    )
    port map (
      clk => clk,
      read_en => otp_read_en,
      read_addr => otp_read_addr,
      read_data => otp_read_data,
      prog_en => otp_prog_en,
      prog_addr => otp_prog_addr,
      prog_bit => otp_prog_bit,
      prog_data => otp_prog_data
    );
    
  otp_load: entity work.otp_load
    port map (
      clk => clk, rst_n => rst_n,
      otp_key => otp_key,
      otp_key_valid => otp_key_valid,
      otp_read_en => otp_read_en,
      otp_read_addr => otp_read_addr,
      otp_read_data => otp_read_data
    );

end architecture;
