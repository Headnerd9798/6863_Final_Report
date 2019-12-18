LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY OPR_NR_UCMP IS
    PORT 
    (
        a    : IN std_logic_vector(3 DOWNTO 0);
        b    : IN std_logic_vector(1 DOWNTO 0);
        c    : IN std_logic_vector(1 DOWNTO 0);
        d    : IN std_logic_vector(4 DOWNTO 0);
        out2 : OUT std_logic
    );
END OPR_NR_UCMP;

ARCHITECTURE OPR_NR_UCMP_rtl OF OPR_NR_UCMP IS
    SIGNAL out1 : std_logic;
BEGIN
    PROCESS (a, b, c, d)
    BEGIN
        IF (a = b) THEN
            out2 <= '1';
        ELSIF (b = c) THEN
            out2 <= '1';
        ELSE
            out2 <= '1';
        END IF;
    END PROCESS;
END OPR_NR_UCMP_rtl;
