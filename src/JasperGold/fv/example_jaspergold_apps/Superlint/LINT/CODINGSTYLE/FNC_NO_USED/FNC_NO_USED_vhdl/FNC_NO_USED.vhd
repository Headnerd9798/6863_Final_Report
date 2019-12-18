LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FNC_NO_USED IS
	PORT
	(
		in_a  : IN std_logic;
		in_b  : IN std_logic;
		out_a : OUT std_logic;
		out_b : OUT std_logic);
END FNC_NO_USED;

ARCHITECTURE FNC_NO_USED_rtl OF FNC_NO_USED IS
	SIGNAL sig_a : std_logic;
	FUNCTION fnc_a (
		in_a         : IN std_logic)RETURN std_logic IS
		VARIABLE v_a : std_logic := '0';
	BEGIN
		v_a := in_a;
		RETURN v_a;
	END FUNCTION fnc_a;

BEGIN
	PROCESS (in_a, in_b)
	BEGIN
		out_a <= in_a AND in_b;
		out_b <= sig_a;
	END PROCESS;
END FNC_NO_USED_rtl;
