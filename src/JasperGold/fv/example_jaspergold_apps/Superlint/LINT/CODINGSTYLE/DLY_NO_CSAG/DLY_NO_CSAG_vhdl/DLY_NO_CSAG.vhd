LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY DLY_NO_CSAG IS
	PORT 
	(
		KOSignal : IN std_logic;
		ena      : IN std_logic;
		sort     : OUT std_logic;
		del2     : OUT std_logic
	);
END DLY_NO_CSAG;
ARCHITECTURE DLY_NO_CSAG_rtl OF DLY_NO_CSAG IS
BEGIN
	sort <= KOSignal AFTER 5 ns WHEN ena = '1';
	del2 <= KOSignal WHEN ena = '1';
END DLY_NO_CSAG_rtl;
