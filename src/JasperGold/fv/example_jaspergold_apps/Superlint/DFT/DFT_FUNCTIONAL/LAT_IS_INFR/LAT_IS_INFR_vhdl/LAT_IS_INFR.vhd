LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY LAT_IS_INFR IS
	PORT
	(
		din  : IN std_logic;
		dout : OUT std_logic;
		clk  : IN std_logic
	);
END LAT_IS_INFR;

ARCHITECTURE LAT_IS_INFR_rtl OF LAT_IS_INFR IS
BEGIN
	PROCESS (clk, din)
	BEGIN
		IF clk = '1' THEN
			dout <= din;
		END IF;
	END PROCESS;
END LAT_IS_INFR_rtl;
