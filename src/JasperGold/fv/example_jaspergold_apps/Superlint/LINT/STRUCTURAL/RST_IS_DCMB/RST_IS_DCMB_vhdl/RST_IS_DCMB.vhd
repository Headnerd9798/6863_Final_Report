LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RST_IS_DCMB IS
    PORT 
    (
        data  : IN std_logic;
        clk   : IN std_logic;
        rst_a : IN std_logic;
        rst_b : IN std_logic;
        q     : OUT std_logic
    );
END RST_IS_DCMB;

ARCHITECTURE RST_IS_DCMB_rtl OF RST_IS_DCMB IS
    SIGNAL reset : std_logic;
BEGIN
    reset <= rst_a AND rst_b;
    PROCESS (clk, reset, data)
    BEGIN
        IF reset = '0' THEN
            q <= '0';
        ELSIF clk = '1' AND clk'EVENT THEN
            q <= data;
        END IF;
    END PROCESS;
END RST_IS_DCMB_rtl;
