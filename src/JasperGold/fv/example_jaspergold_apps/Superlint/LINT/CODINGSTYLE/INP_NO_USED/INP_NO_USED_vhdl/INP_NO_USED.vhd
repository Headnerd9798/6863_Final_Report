LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY INP_NO_USED IS
    PORT 
    (
        in1  : IN std_logic;
        out1 : OUT std_logic_vector (6 DOWNTO 0)
    );
END INP_NO_USED;

ARCHITECTURE INP_NO_USED_rtl OF INP_NO_USED IS
    SIGNAL p1 : std_logic_vector (3 DOWNTO 0) := "0110";
    SIGNAL p2 : std_logic_vector (3 DOWNTO 0) := "1010";
BEGIN
    out1 <= p1 & p2(1) & p2(2) & p2(3);
END INP_NO_USED_rtl;
