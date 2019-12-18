LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FNC_NR_NARG IS
    PORT (i1 : IN std_logic);
END FNC_NR_NARG;

ARCHITECTURE FNC_NR_NARG_rtl OF FNC_NR_NARG IS
    SIGNAL w1                     : std_logic;
    FUNCTION indent(my_in, my_in2 : IN std_logic) RETURN std_logic IS
    BEGIN
        RETURN my_in;
    END indent;
BEGIN
    PROCESS (i1)
    BEGIN
        w1 <= indent(i1);
    END PROCESS;
END FNC_NR_NARG_rtl;
