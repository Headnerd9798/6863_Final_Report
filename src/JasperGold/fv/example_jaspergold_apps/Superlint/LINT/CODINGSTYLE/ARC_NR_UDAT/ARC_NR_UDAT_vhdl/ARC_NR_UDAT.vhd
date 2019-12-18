LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY and2 IS
	GENERIC (size : INTEGER := 3);
	PORT
	(
		in_a  : IN unsigned (size DOWNTO 0);
		in_b  : IN unsigned (size DOWNTO 0);
		out_a : OUT unsigned (size DOWNTO 0));
END and2;
ARCHITECTURE rtl_and2 OF and2 IS
BEGIN
	out_a <= in_a AND in_b;
END rtl_and2;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY ARC_NR_UDAT IS
	GENERIC (size : INTEGER := 3);
	PORT
	(
		in_a  : IN unsigned (size DOWNTO 0);
		out_a : OUT unsigned (size DOWNTO 0));
END ARC_NR_UDAT;
ARCHITECTURE ARC_NR_UDAT_rtl OF ARC_NR_UDAT IS
	COMPONENT and2
		PORT
		(
			in_a  : IN unsigned (size DOWNTO 0);
			in_b  : IN unsigned (size DOWNTO 0);
			out_a : OUT unsigned (size DOWNTO 0));
	END COMPONENT;
	SIGNAL s                       : unsigned(size DOWNTO 0);
	SIGNAL s_a                     : BOOLEAN;
	ATTRIBUTE Preserve_signal      : BOOLEAN;
	ATTRIBUTE Preserve_signal OF s : SIGNAL IS true;
BEGIN
	U1 : and2 PORT MAP
		(in_a => in_a, in_b => s, out_a => out_a);
	s_a <= s'Preserve_signal;
END ARC_NR_UDAT_rtl;
