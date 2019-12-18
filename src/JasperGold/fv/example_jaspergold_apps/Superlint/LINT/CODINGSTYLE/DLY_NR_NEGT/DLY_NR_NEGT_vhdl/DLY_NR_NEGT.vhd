LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DLY_NR_NEGT IS
	PORT
	(
		in_a, in_b, sel : IN std_logic;
		out_a           : OUT std_logic);
END DLY_NR_NEGT;

ARCHITECTURE DLY_NR_NEGT_rtl OF DLY_NR_NEGT IS
BEGIN
	PROCESS (in_a, in_b, sel)
	BEGIN
		IF sel = '1' THEN
			out_a <= in_a AFTER 10 ns;
		ELSE
			out_a <= in_b AFTER -10 ns;
		END IF;
	END PROCESS;
END DLY_NR_NEGT_rtl;
