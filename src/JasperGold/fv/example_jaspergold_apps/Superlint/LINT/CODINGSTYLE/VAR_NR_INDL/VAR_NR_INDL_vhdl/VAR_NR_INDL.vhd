LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY VAR_NR_INDL IS
    PORT (count : OUT std_logic_vector(1 DOWNTO 0));
END VAR_NR_INDL;

ARCHITECTURE VAR_NR_INDL_rtl OF VAR_NR_INDL IS
    SIGNAL sig1 : std_logic_vector(1 DOWNTO 0) := "01";
BEGIN
    count <= sig1;
END VAR_NR_INDL_rtl;
