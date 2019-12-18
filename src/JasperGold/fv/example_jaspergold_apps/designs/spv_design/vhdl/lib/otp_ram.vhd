library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity otp_ram is
  generic (
    ADDR_W: integer := 3
  );
  port (
    clk: in std_logic;
    read_en: in std_logic;
    read_addr: in std_logic_vector(ADDR_W-1 downto 0);
    read_data: out std_logic_vector(7 downto 0);
    prog_en: in std_logic;
    prog_addr: in std_logic_vector(ADDR_W-1 downto 0);
    prog_bit: in std_logic_vector(2 downto 0);
    prog_data: in std_logic
  );
end entity;

architecture rtl of otp_ram is
  constant SIZE: integer := (2**ADDR_W);
  type otp_array is array (0 to SIZE-1) of std_logic_vector(7 downto 0);
  signal mem, programmed: otp_array;
  signal prog_addr_int, read_addr_int: integer range 0 to SIZE-1;
  signal prog_bit_int: integer range 0 to 7;
begin

  prog_addr_int <= to_integer(unsigned(prog_addr));
  prog_bit_int <= to_integer(unsigned(prog_bit));
  read_addr_int <= to_integer(unsigned(read_addr));

  process (clk) begin
    if (rising_edge(clk)) then
      if (prog_en = '1' AND programmed(prog_addr_int)(prog_bit_int) = '0') then
        mem(prog_addr_int)(prog_bit_int) <= prog_data;
        programmed(prog_addr_int)(prog_bit_int) <= '1';
      end if;
      if (read_en = '1') then
        read_data <= mem(read_addr_int);
      end if;
    end if;
  end process;

end architecture;
