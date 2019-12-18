LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY IDN_NR_VKYW IS
	PORT
	(
		d_in  : IN INTEGER;
		d_out : OUT INTEGER
        );
END ENTITY IDN_NR_VKYW;
ARCHITECTURE IDN_NR_VKYW_rtl OF IDN_NR_VKYW IS
BEGIN
	alu : PROCESS IS
	        PROCEDURE do_arith(
			SIGNAL tri                : IN INTEGER) IS
			VARIABLE always, weak1, b : INTEGER;
		BEGIN
			always := tri;
			b      := + always + tri;
			d_out <= b + always;
		END PROCEDURE do_arith;
	BEGIN
		do_arith(d_in);
	END PROCESS alu;
END ARCHITECTURE IDN_NR_VKYW_rtl;
