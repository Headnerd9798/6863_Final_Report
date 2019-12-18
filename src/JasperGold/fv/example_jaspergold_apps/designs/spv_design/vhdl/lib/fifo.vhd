library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
  generic (
    PTR_W: integer := 4;
    DATA_W: integer := 8
  );
  port (
    clk, rst_n: in std_logic;
    push, pop: in std_logic;
    full, empty: out std_logic;
    data_in: in std_logic_vector(DATA_W-1 downto 0);
    data_out: out std_logic_vector(DATA_W-1 downto 0);
    level: buffer std_logic_vector(PTR_W downto 0)
  );
end entity;

architecture rtl of fifo is
  constant SIZE: integer := (2**PTR_W);
  signal wrptr, rdptr: std_logic_vector(PTR_W downto 0);
  type fifo_array is array (0 to SIZE-1) of std_logic_vector(DATA_W-1 downto 0);
  signal mem: fifo_array;
begin

  process (clk, rst_n) begin
    if (rst_n = '0') then
      wrptr <= (others => '0');
      rdptr <= (others => '0');
    elsif (rising_edge(clk)) then
      if (push = '1') then
        mem(to_integer(unsigned(wrptr(PTR_W-1 downto 0)))) <= data_in;
        wrptr <= std_logic_vector(unsigned(wrptr) + 1);
      end if;
      if (pop = '1') then
        rdptr <= std_logic_vector(unsigned(rdptr) + 1);
      end if;
    end if;
  end process;

  data_out <= mem(to_integer(unsigned(rdptr(PTR_W-1 downto 0))));
  
  level <= std_logic_vector(unsigned(wrptr) - unsigned(rdptr));
  empty <= '1' when (unsigned(level) = 0) else '0';
  full <= '1' when (unsigned(level) = SIZE) else '0';

end architecture;
