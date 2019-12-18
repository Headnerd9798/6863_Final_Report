LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FLP_NR_MXCS IS
	PORT (
		in1 : IN std_logic;
		in2 : IN std_logic;
		clk : IN std_logic;
		rst : IN std_logic;
		out1 : OUT std_logic);
END FLP_NR_MXCS;

ARCHITECTURE FLP_NR_MXCS_rtl OF FLP_NR_MXCS IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '0') THEN
			out1 <= '0';
		ELSIF clk = '1' AND clk'event THEN
			out1 <= in1 AND in2;
		END IF;
	END PROCESS;
END FLP_NR_MXCS_rtl;
