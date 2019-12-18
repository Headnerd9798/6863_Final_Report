LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bottom IS
	PORT
	(
		out_a : OUT std_logic_vector(2 DOWNTO 0);
		in_a  : IN std_logic_vector(2 DOWNTO 0)
	);
END bottom;

ARCHITECTURE bottom_rtl OF bottom IS
BEGIN
	out_a <= NOT(in_a);
END bottom_rtl;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IDX_MS_INDL IS
	PORT
	(
		out_a : OUT std_logic_vector(2 DOWNTO 0);
		in_a  : IN std_logic_vector(2 DOWNTO 0)
	);
END IDX_MS_INDL;

ARCHITECTURE IDX_MS_INDL_rtl OF IDX_MS_INDL IS
	COMPONENT bottom
		PORT
		(
			out_a : OUT std_logic_vector(4 DOWNTO 2);
			in_a  : IN std_logic_vector(2 DOWNTO 0)
		);
	END COMPONENT;
	SIGNAL clk : std_logic;
	SIGNAL rec : std_logic_vector(2 DOWNTO 0);
BEGIN
	b1 : bottom PORT MAP
		(out_a => out_a, in_a => in_a);
	PROCESS (clk)
	BEGIN
		IF clk = '1' AND clk'event THEN
			out_a <= rec;
		END IF;
	END PROCESS;
END IDX_MS_INDL_rtl;
