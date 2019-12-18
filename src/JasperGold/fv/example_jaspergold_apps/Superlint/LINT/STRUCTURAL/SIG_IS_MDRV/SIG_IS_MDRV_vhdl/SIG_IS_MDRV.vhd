LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SIG_IS_MDRV IS
    PORT 
    (
        a   : IN std_logic;
        b   : IN std_logic;
        clk : IN std_logic;
        q   : OUT std_logic
    );
END SIG_IS_MDRV;

ARCHITECTURE SIG_IS_MDRV_rtl OF SIG_IS_MDRV IS
BEGIN
    p1 : PROCESS (clk)
    BEGIN
        IF clk = '1' AND clk'EVENT THEN
            q <= a AND b;
        END IF;
    END PROCESS p1;

    p2 : PROCESS
    BEGIN
        q <= '1';
    END PROCESS p2;

END SIG_IS_MDRV_rtl;
