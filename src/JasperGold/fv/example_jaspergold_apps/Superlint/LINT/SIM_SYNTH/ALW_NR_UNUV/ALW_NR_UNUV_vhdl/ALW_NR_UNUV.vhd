LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALW_NR_UNUV IS
    PORT 
    (
        in1  : IN std_logic;
        in2  : IN std_logic;
        out1 : OUT std_logic;
        out2 : OUT std_logic
    );
END ALW_NR_UNUV;

ARCHITECTURE ALW_NR_UNUV_rtl OF ALW_NR_UNUV IS
BEGIN
    PROCESS (in1, in2)
    BEGIN
        out2 <= '0';
    END PROCESS;

    out1 <= in1 AND in2;

END ALW_NR_UNUV_rtl;
