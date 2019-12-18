LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FLP_NR_ASMX IS
	PORT (clk, rst : IN std_logic;
	port_a : IN std_logic;
	port_b : IN std_logic;
	port_c : OUT std_logic;
	port_d : OUT std_logic);
END FLP_NR_ASMX;

ARCHITECTURE FLP_NR_ASMX_rtl OF FLP_NR_ASMX IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '0') THEN
			port_c <= '0';
		ELSIF clk = '1' AND clk'event THEN
			port_c <= port_a;
			port_d <= port_b;
		END IF;
	END PROCESS;
END FLP_NR_ASMX_rtl;
