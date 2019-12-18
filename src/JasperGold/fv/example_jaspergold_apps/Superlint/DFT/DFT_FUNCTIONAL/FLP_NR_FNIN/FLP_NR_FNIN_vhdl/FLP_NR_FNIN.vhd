LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FLP_NR_FNIN IS
	PORT (
		a, b, clk, rst : IN std_logic;
		c : IN std_logic_vector(127 DOWNTO 0)
	);
END FLP_NR_FNIN;

ARCHITECTURE FLP_NR_FNIN_rtl OF FLP_NR_FNIN IS
	SIGNAL f, w1, w2 : std_logic;
BEGIN
	w1 <= NOR c;
	w2 <= a AND b AND w1;

	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			f <= '0';
		ELSIF clk = '1' AND clk'EVENT THEN
			f <= w2;
		END IF;
	END PROCESS;
END FLP_NR_FNIN_rtl;
