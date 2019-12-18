LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CLK_XC_LDTH IS
	PORT (
		in_a, in_b, rst, clk : IN std_logic;
		out_a, out_b         : OUT std_logic);
END CLK_XC_LDTH;

ARCHITECTURE CLK_XC_LDTH_rtl OF CLK_XC_LDTH IS
BEGIN
	out_b <= clk AND in_b;
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '0') THEN
			out_a <= '0';
		ELSIF clk = '1' AND clk'event THEN
			out_a <= in_a;
		END IF;
	END PROCESS;
END CLK_XC_LDTH_rtl;
