LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FNC_NR_RETV IS
	PORT (
		clk, rst : IN std_logic;
		in1 : IN std_logic_vector (3 DOWNTO 0);
		out1 : OUT std_logic_vector (4 DOWNTO 1));
END FNC_NR_RETV;
ARCHITECTURE FNC_NR_RETV_rtl OF FNC_NR_RETV IS
	TYPE s1 IS ARRAY (5 DOWNTO 0) OF std_logic_vector(3 DOWNTO 0);
	TYPE s2 IS ARRAY (6 DOWNTO 1) OF std_logic_vector(4 DOWNTO 1);
	SUBTYPE s3 IS std_logic_vector(3 DOWNTO 0);
	FUNCTION PARITY (X : std_logic_vector(3 DOWNTO 0))
		RETURN s3 IS
		VARIABLE ret : s2;
	BEGIN
		ret(6) := X;
		RETURN ret(6);
	END PARITY;
BEGIN
	PROCESS
	BEGIN
		out1 <= PARITY(in1);
	END PROCESS;
END FNC_NR_RETV_rtl;
