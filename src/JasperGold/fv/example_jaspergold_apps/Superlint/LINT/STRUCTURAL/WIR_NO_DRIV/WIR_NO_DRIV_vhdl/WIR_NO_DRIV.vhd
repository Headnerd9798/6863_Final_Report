LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY WIR_NO_DRIV IS
	PORT
	(
		in1, clk1 : IN std_logic;
		out1      : OUT std_logic
	);
END WIR_NO_DRIV;
ARCHITECTURE WIR_NO_DR_rtl OF WIR_NO_DRIV IS
	COMPONENT lop
		PORT
		(
			in2, clk2 : IN std_logic;
			out2      : OUT std_logic
		);
	END COMPONENT;
BEGIN
	U1 : lop
	PORT MAP(in2 => in1, clk2 => clk1, out2 => out1);
END WIR_NO_DR_rtl;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY lop IS
	PORT
	(
	in2, clk2 : IN std_logic;
	out2      : OUT std_logic
	);
END lop;
ARCHITECTURE lop_rtl OF lop IS
	SIGNAL a : std_logic;
	COMPONENT cot
		PORT
		(
			in3, clk3 : IN std_logic;
			out3      : OUT std_logic
		);
	END COMPONENT;
BEGIN
	C1 : cot
	PORT MAP(in3 => in2, clk3 => clk2, out3 => a);
	out2 <= a;
END lop_rtl;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY cot IS
	PORT
	(
	in3, clk3 : IN std_logic;
	out3      : OUT std_logic
	);
END cot;
ARCHITECTURE cot_rtl OF cot IS
BEGIN
END cot_rtl;
