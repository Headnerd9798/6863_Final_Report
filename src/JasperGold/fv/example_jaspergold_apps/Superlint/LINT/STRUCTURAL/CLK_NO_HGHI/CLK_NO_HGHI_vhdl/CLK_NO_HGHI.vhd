LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test_c IS
	PORT (
		clk_a, in_a : IN std_logic;
		clk_b       : OUT std_logic);
END test_c;

ARCHITECTURE test_c_rtl OF test_c IS
BEGIN
	PROCESS (clk_a)
	BEGIN
		IF clk_a = '1' AND clk_a'event THEN
			clk_b <= in_a;
		END IF;
	END PROCESS;
END test_c_rtl;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test_b IS
	PORT (
		clk_a, in_a : IN std_logic;
		clk_b       : OUT std_logic);
END test_b;

ARCHITECTURE test_b_rtl OF test_b IS
BEGIN
	T_c : ENTITY work.test_c PORT MAP (clk_a, in_a, clk_b);
END test_b_rtl;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CLK_NO_HGHI IS
	PORT (
		clk, rst   : IN std_logic;
		in_a, in_b : IN std_logic;
		out_a      : OUT std_logic);
END CLK_NO_HGHI;

ARCHITECTURE CLK_NO_HGHI_rtl OF CLK_NO_HGHI IS
	SIGNAL clk_b : std_logic;
BEGIN
	PROCESS (clk_b, rst)
	BEGIN
		IF rst = '1' THEN
			out_a <= '0';
		ELSIF clk_b'event AND clk_b = '1' THEN
			out_a <= in_a;
		END IF;
	END PROCESS;
	T_B : ENTITY work.test_b PORT MAP (clk, in_b, clk_b);
END CLK_NO_HGHI_rtl;
