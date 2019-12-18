LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DFF IS
	PORT (
		in_a, clk, rst : IN std_logic;
		out_a          : OUT std_logic);
END DFF;

ARCHITECTURE DFF_rtl OF DFF IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '0') THEN
			out_a <= '0';
		ELSIF clk = '1' AND clk'event THEN
			out_a <= in_a;
		END IF;
	END PROCESS;
END DFF_rtl;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CMB_NR_TLIO IS
	PORT (
		in_a, in_b, clk, rst : IN std_logic;
		out_a, out_b         : OUT std_logic);
END CMB_NR_TLIO;

ARCHITECTURE CMB_NR_TLIO_rtl OF CMB_NR_TLIO IS
BEGIN
	DFF : ENTITY work.DFF PORT MAP(in_a, clk, rst, out_a);
	out_b <= out_a AND in_b;
END CMB_NR_TLIO_rtl;
