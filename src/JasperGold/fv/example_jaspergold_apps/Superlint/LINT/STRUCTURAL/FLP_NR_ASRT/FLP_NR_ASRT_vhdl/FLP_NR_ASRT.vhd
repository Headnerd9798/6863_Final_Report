LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FLP_NR_ASRT IS
    PORT 
    (
        clk    : IN std_logic;
        reset  : IN std_logic;
        set    : IN std_logic;
        port_a : IN std_logic;
        port_b : OUT std_logic
    );
END FLP_NR_ASRT;

ARCHITECTURE FLP_NR_ASRT_rtl OF FLP_NR_ASRT IS
BEGIN
    PROCESS (reset, set, clk, port_a)
    BEGIN
        IF reset = '0' THEN
            port_b <= '0';
        ELSIF set = '1' THEN
            port_b <= '1';
        ELSIF clk = '1' AND clk'EVENT THEN
            port_b <= port_a;
        END IF;
    END PROCESS;
END FLP_NR_ASRT_rtl;
