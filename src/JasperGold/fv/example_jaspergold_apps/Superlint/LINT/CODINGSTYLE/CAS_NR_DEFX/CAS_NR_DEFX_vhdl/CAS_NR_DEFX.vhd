LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CAS_NR_DEFX IS
	PORT (
		ip, sel : IN std_logic;
		outp : OUT std_logic_vector(1 DOWNTO 0));
END CAS_NR_DEFX;

ARCHITECTURE CAS_NR_DEFX_rtl OF CAS_NR_DEFX IS
BEGIN
	PROCESS (sel)
	BEGIN
		CASE sel IS
			WHEN '0' => outp(0) <= '0';
			WHEN '1' => outp(1) <= '1';
			WHEN OTHERS => outp(1) <= 'X';
		END CASE;
	END PROCESS;
END CAS_NR_DEFX_rtl;
