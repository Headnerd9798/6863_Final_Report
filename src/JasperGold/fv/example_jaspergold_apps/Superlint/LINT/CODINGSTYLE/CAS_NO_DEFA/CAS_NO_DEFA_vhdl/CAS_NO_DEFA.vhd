LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CAS_NO_DEFA IS
	PORT
	(
		in_a, in_b, in_c, in_d : IN std_logic;
		sel                    : IN std_logic_vector (19 DOWNTO 0);
		out_a                  : OUT std_logic);
END CAS_NO_DEFA;

ARCHITECTURE CAS_NO_DEFA_rtl OF CAS_NO_DEFA IS
BEGIN
	PROCESS (in_a, in_b, in_c, in_d, sel)
	BEGIN
		CASE sel IS
			WHEN x"00FFF" => out_a <= in_a;
			WHEN x"0FFF0" => out_a <= in_b;
			WHEN x"FFF00" => out_a <= in_c;
			WHEN x"F0FF0" => out_a <= in_d;
		END CASE;
	END PROCESS;
END CAS_NO_DEFA_rtl;
