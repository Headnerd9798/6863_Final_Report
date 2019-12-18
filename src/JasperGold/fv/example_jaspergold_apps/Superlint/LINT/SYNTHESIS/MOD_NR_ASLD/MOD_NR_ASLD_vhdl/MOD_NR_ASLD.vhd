LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MOD_NR_ASLD IS
    PORT 
    (
        clk : IN std_logic;
        d   : IN std_logic;
        rst : IN std_logic;
        q   : OUT std_logic
    );
END MOD_NR_ASLD;

ARCHITECTURE MOD_NR_ASLD_rtl OF MOD_NR_ASLD IS
    SIGNAL p : std_logic;
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            q <= p;
        ELSIF clk = '1' AND clk'EVENT THEN
            q <= d;
        END IF;
    END PROCESS;
END MOD_NR_ASLD_rtl;
