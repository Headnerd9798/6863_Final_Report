LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CND_NR_EVXZ IS
	PORT
	(
		in_a  : IN std_logic;
		out_a : OUT std_logic;
		out_b : OUT std_logic);
END CND_NR_EVXZ;

ARCHITECTURE CND_NR_EVXZ_rtl OF CND_NR_EVXZ IS
	SIGNAL sig_a : std_logic := 'X';
BEGIN
	PROCESS (sig_a, in_a)
	BEGIN
		CASE sig_a IS
			WHEN '1'    => out_a    <= in_a;
			WHEN OTHERS => out_a <= 'X';
		END CASE;
	END PROCESS;
END CND_NR_EVXZ_rtl;
