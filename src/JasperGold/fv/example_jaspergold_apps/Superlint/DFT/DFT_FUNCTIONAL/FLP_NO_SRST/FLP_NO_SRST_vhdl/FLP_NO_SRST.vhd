LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY FLP_NO_SRST IS
	PORT
	(
		port_a : IN std_logic;
		clk    : IN std_logic;
		port_b : OUT std_logic
	);
END FLP_NO_SRST;
ARCHITECTURE FLP_NO_SRST_rtl OF FLP_NO_SRST IS
BEGIN
	PROCESS (clk)
	BEGIN
		IF clk = '1' AND clk'EVENT THEN
			port_b <= port_a;
		END IF;
	END PROCESS;
END FLP_NO_SRST_rtl;
