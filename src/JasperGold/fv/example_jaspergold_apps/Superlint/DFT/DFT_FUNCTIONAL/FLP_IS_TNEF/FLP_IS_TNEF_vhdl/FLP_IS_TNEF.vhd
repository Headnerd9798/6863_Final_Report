LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FLP_IS_TNEF IS
	PORT (
		i1 : IN std_logic;
		clk : IN std_logic;
		o1 : OUT std_logic);
END FLP_IS_TNEF;

ARCHITECTURE FLP_IS_TNEF_rtl OF FLP_IS_TNEF IS
BEGIN
	PROCESS (clk)
	BEGIN
		IF clk = '0' AND clk'event THEN
			o1 <= i1;
		END IF;
	END PROCESS;
END FLP_IS_TNEF_rtl;
