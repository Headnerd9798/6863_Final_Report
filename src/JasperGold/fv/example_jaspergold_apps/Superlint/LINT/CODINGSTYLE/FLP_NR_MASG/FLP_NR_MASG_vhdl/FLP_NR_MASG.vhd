LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FLP_NR_MASG IS
	PORT (
		port_a : IN std_logic;
		clk : IN std_logic;
		rst : IN std_logic;
		en : IN std_logic;
		port_b : OUT std_logic);
END FLP_NR_MASG;

ARCHITECTURE FLP_NR_MASG_rtl OF FLP_NR_MASG IS
BEGIN
	PROCESS (clk, rst, en)
	BEGIN
		IF ((NOT rst) OR en) THEN
			port_b <= '0';
		ELSIF clk = '1' AND clk'event THEN
			port_b <= port_a;
		END IF;
	END PROCESS;
END FLP_NR_MASG_rtl;
