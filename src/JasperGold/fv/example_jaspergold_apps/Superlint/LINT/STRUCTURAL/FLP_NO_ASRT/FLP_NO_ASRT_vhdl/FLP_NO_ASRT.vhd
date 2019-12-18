LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FLP_NO_ASRT IS
	PORT
	(
		clk, rst, in_a : IN std_logic;
		out_a          : OUT std_logic);
END FLP_NO_ASRT;

ARCHITECTURE FLP_NO_ASRT_rtl OF FLP_NO_ASRT IS
BEGIN
	PROCESS (clk, rst, in_a)
	BEGIN
		IF clk = '1' AND clk'event THEN
			IF rst = '0' THEN
				out_a <= '0';
			ELSE
				out_a <= in_a;
			END IF;
		END IF;
	END PROCESS;
END FLP_NO_ASRT_rtl;
