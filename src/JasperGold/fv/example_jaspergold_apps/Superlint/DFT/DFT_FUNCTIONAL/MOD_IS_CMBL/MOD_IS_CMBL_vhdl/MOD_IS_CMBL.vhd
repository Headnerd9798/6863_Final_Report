LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY MOD_IS_CMBL IS
	PORT
	(
		a, b, c, d, e, f : BUFFER std_logic;
		o, o2            : OUT std_logic
	);
END MOD_IS_CMBL;
ARCHITECTURE MOD_IS_CMBL_rtl OF MOD_IS_CMBL IS
	COMPONENT NAND_2
		PORT
		(
			I0, I1 : IN std_logic;
			o      : BUFFER std_logic
		);
	END COMPONENT;
	COMPONENT OR_2
		PORT
		(
			I0, I1 : IN std_logic;
			o      : BUFFER std_logic
		);
	END COMPONENT;
BEGIN
	x1 : NAND_2
	PORT MAP(a, b, c);
	x2 : OR_2
	PORT MAP(c, d, b);
END MOD_IS_CMBL_rtl;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY nand_2 IS
	PORT
	(
	I0, I1 : IN std_logic;
	o      : BUFFER std_logic
	);
END;
ARCHITECTURE NAND_2_rtl OF NAND_2 IS
BEGIN
	O <= I0 NAND I1;
END NAND_2_rtl;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY OR_2 IS
	PORT
	(
	I0, I1 : IN std_logic;
	o      : BUFFER std_logic
	);
END ENTITY;
ARCHITECTURE OR_2_rtl OF OR_2 IS
BEGIN
	O <= I0 OR I1;
END OR_2_rtl;
