LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SIG_IS_INTB IS
    PORT 
    (
        port_a : IN std_logic_vector(1 DOWNTO 0);
        port_b : IN std_logic;
        outp   : OUT std_logic_vector(1 DOWNTO 0)
    );
END SIG_IS_INTB;

ARCHITECTURE SIG_IS_INTB_rtl OF SIG_IS_INTB IS
BEGIN
    outp <= port_a WHEN port_b = '1' ELSE
            "ZZ";
END SIG_IS_INTB_rtl;
