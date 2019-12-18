LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE ApprovedType IS
	TYPE LEC_ECR IS (LECTURE, ECRITURE);
	CONSTANT TAILLE_MAX : INTEGER := 200;
	SUBTYPE TAILLE IS INTEGER RANGE 0 TO TAILLE_MAX;
	SIGNAL KOsignal1, KOsignal2, KOsignal3 : std_logic;
	FUNCTION SIMPLE_SUB_min(A              : IN std_logic;
		B                                      : IN std_logic
	) RETURN std_logic;
END ApprovedType;

PACKAGE BODY ApprovedType IS
	FUNCTION SIMPLE_SUB_min(A : IN std_logic;
		B                         : IN std_logic)
		RETURN std_logic IS
	BEGIN
		IF A < B THEN
			RETURN A;
		ELSE
			RETURN B;
		END IF;
	END SIMPLE_SUB_min;
END ApprovedType;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.ApprovedType.ALL;

ENTITY ARC_NR_GLSG IS
	PORT
		(out_a : OUT std_logic);
END ARC_NR_GLSG;

ARCHITECTURE ARC_NR_GLSG_rtl OF ARC_NR_GLSG IS
BEGIN
	P1 : PROCESS (KOsignal1, KOsignal2)
	BEGIN
		out_a <= SIMPLE_SUB_min(KOsignal3, KOsignal1);
	END PROCESS P1;
END ARC_NR_GLSG_rtl;
