LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IDN_NR_AMKW IS
	PORT
	(
	        in_a, in_b : IN std_logic;
	        above      : OUT std_logic);
END IDN_NR_AMKW;

ARCHITECTURE IDN_NR_AMKW_rtl OF IDN_NR_AMKW IS
BEGIN
        above <= in_a AND in_b;
END IDN_NR_AMKW_rtl;
