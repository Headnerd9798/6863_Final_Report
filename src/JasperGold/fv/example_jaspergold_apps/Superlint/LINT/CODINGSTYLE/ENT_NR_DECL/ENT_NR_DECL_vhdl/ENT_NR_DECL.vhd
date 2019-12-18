LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY ENT_NR_DECL IS
	GENERIC (g_a : INTEGER := 8);
	PORT
	(
		in_b  : IN std_logic;
		i_a   : OUT INTEGER;
		out_a : OUT std_logic);
	TYPE Instruction IS ARRAY(1 TO 5) OF NATURAL;
	TYPE Program IS ARRAY(NATURAL RANGE <>) OF Instruction;
	CONSTANT ROM_Code : Program :=
	(
	(20, 10, 11, 47, 5),
	(15, 55, 66, 8, 14)
	);
END ENT_NR_DECL;
ARCHITECTURE ENT_NR_DECL_rtl OF ENT_NR_DECL IS
	TYPE desc_level IS (behavioral, rtl, structural);
	ATTRIBUTE description_level                    : desc_level;
	ATTRIBUTE description_level OF ENT_NR_DECL_rtl : ARCHITECTURE IS rtl;
BEGIN
	out_a <= in_b;
	i_a   <= g_a;
END ENT_NR_DECL_rtl;
