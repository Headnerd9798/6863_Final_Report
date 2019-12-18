LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test IS
	PORT (
		a, b : IN std_logic;
		o : OUT std_logic_vector(2 DOWNTO 0));
END test;

ARCHITECTURE test_rtl OF test IS
BEGIN
	o <= a & b;
END test_rtl;
