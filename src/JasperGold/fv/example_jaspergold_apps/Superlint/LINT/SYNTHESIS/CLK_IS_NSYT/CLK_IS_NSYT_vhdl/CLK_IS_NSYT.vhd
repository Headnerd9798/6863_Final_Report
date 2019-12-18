LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY CLK_IS_NSYT IS
	PORT
	(
		clock_a : IN std_logic;
		clock_b : IN std_logic;
		reset   : IN BOOLEAN;
		in_a    : IN std_logic;
		out_a   : OUT std_logic
	);
END CLK_IS_NSYT;

ARCHITECTURE CLK_IS_NSYT_rtl OF CLK_IS_NSYT IS
BEGIN
	PROCESS (clock_a, reset)
	BEGIN
		IF (clock_a'event AND clock_a = '1') THEN
			out_a <= in_a;
		ELSIF (reset) THEN
			out_a <= '0';
		END IF;
	END PROCESS;
END CLK_IS_NSYT_rtl;
