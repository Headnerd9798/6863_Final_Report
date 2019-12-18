LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RST_IS_DDAF IS
	PORT (
		port_a : IN std_logic;
		clk, rst : IN std_logic;
		port_c : OUT std_logic;
		port_b : OUT std_logic);
END RST_IS_DDAF;

ARCHITECTURE RST_IS_DDAF_rtl OF RST_IS_DDAF IS
BEGIN
	P1 : PROCESS (clk, rst)
	BEGIN
		IF (rst = '0') THEN
			port_b <= '0';
		ELSIF clk = '1' AND clk'event THEN
			port_b <= port_a;
		END IF;
	END PROCESS P1;

	P2 : PROCESS (clk)
	BEGIN
		IF clk = '1' AND clk'event THEN
			port_c <= rst;
		END IF;
	END PROCESS P2;
END RST_IS_DDAF_rtl;
