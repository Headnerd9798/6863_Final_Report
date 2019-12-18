library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity otp_load is
  port (
    clk, rst_n: in std_logic;

    otp_key: out std_logic_vector(31 downto 0);
    otp_key_valid: out std_logic;

    otp_read_en: buffer std_logic;
    otp_read_addr: buffer std_logic_vector(1 downto 0);
    otp_read_data: in std_logic_vector(7 downto 0)
  );
end otp_load;

architecture rtl of otp_load is
  signal key: std_logic_vector(31 downto 0);
  signal key_valid: std_logic_vector(3 downto 0);
begin

  otp_key <= key;
  otp_key_valid <= '1' when (key_valid = "1111") else '0';

  process (clk, rst_n) begin
    if (rst_n = '0') then
      key_valid <= "0000";
      otp_read_en <= '0';
    elsif (rising_edge(clk)) then
      if (otp_read_en = '1') then
        case (otp_read_addr) is
          when "00" =>
            key_valid(0) <= '1';
            key(7 downto 0) <= otp_read_data;
          when "01" =>
            key_valid(1) <= '1';
            key(15 downto 8) <= otp_read_data;
          when "10" =>
            key_valid(2) <= '1';
            key(23 downto 16) <= otp_read_data;
          when "11" =>
            key_valid(3) <= '1';
            key(31 downto 24) <= otp_read_data;
          when others =>
        end case;
        otp_read_en <= '0';
      else
        if (key_valid(0) = '0') then
          otp_read_en <= '1';
          otp_read_addr <= "00";
        elsif (key_valid(1) = '0') then
          otp_read_en <= '1';
          otp_read_addr <= "01";
        elsif (key_valid(2) = '0') then
          otp_read_en <= '1';
          otp_read_addr <= "10";
        elsif (key_valid(3) = '0') then
          otp_read_en <= '1';
          otp_read_addr <= "11";
        end if;
      end if;
    end if;
  end process;

end architecture;
