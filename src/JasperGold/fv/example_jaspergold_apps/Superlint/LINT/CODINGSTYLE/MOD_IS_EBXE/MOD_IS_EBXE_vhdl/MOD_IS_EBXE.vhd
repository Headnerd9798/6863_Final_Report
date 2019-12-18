LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MOD_IS_EBXE IS
	PORT (
		a, b : IN std_logic;
		o : OUT std_logic_vector (2 DOWNTO 0));
END MOD_IS_EBXE;

ARCHITECTURE MOD_IS_EBXE_rtl OF MOD_IS_EBXE IS
BEGIN
	test1 : ENTITY work.test(test_rtl) PORT MAP (a => a, b => b, o => o);
END MOD_IS_EBXE_rtl;
