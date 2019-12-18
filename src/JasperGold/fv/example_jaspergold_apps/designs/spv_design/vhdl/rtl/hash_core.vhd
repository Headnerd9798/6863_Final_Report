library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hash_core is
  port (
    clk, rst_n: in std_logic;

    key: in std_logic_vector(31 downto 0);

    in_valid: in std_logic;
    in_data, in_prev: in std_logic_vector(31 downto 0);

    busy: buffer std_logic;

    out_valid: out std_logic;
    out_hash: out std_logic_vector(31 downto 0)
  );
end hash_core;

architecture rtl of hash_core is
  signal cnt: unsigned (1 downto 0);
  signal data, prev: std_logic_vector(31 downto 0);
  signal key_rot_right, key_rot_left: std_logic_vector(31 downto 0);
begin

  key_rot_right <= (key(7 downto 0) & key(31 downto 8));
  key_rot_left <= (key(23 downto 0) & key(31 downto 24));

  out_valid <= '1' when (cnt = 2) else '0';
  out_hash <= std_logic_vector(unsigned(data) + unsigned(prev));

  busy <= '1' when (cnt > 0) else '0';

  process (clk, rst_n) begin
    if (rst_n = '0') then
      cnt <= "00";
    elsif (rising_edge(clk)) then
      if (in_valid = '1') then
        cnt <= "01";
        data <= in_data;
        prev <= in_prev;
      end if;
      if (busy = '1') then
        data <= std_logic_vector(unsigned(prev XOR key_rot_right) + unsigned(data XOR (NOT key_rot_left)));
        prev <= (data(23 downto 0) & data(31 downto 24));
        if (cnt = 2) then
          cnt <= "00";
        else
          cnt <= cnt + 1;
        end if;
      end if;
    end if;
  end process;

end architecture;
