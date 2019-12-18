LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CND_IR_CCAS IS
	GENERIC (ga : INTEGER := 1);
	PORT
	(
		in_a  : IN std_logic_vector (2 DOWNTO 0);
		out_b : OUT std_logic_vector (1 DOWNTO 0);
		out_c : OUT std_logic_vector (1 DOWNTO 0));
END CND_IR_CCAS;

ARCHITECTURE CND_IR_CCAS_rtl OF CND_IR_CCAS IS
	SIGNAL sig   : INTEGER := 1;
	SIGNAL sig_a : BOOLEAN;
	SIGNAL sig_b : BOOLEAN;
	SIGNAL sig_c : std_logic;
BEGIN
	PROCESS (in_a, sig_a, sig_b)
	BEGIN
		CASE 1 IS
			WHEN 1      => out_b <= "00";
			WHEN OTHERS => out_b <= "XX";
		END CASE;
        END PROCESS;
END CND_IR_CCAS_rtl;
