LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RST_IS_DFLP IS
    PORT 
    (
        port_a : IN std_logic;
        clk    : IN std_logic;
        rst_a  : IN std_logic;
        port_c : OUT std_logic
    );
END RST_IS_DFLP;

ARCHITECTURE RST_IS_DFLP_rtl OF RST_IS_DFLP IS
    SIGNAL rst : std_logic;
BEGIN
    p1 : PROCESS (clk, rst_a)
    BEGIN
        IF clk = '1' AND clk'EVENT THEN
            rst <= NOT rst_a;
        END IF;
    END PROCESS p1;

    p2 : PROCESS (clk, rst, port_a)
    BEGIN
        IF rst = '0' THEN
            port_c <= '0';
        ELSIF clk = '1' AND clk'EVENT THEN
            port_c <= port_a;
        END IF;
    END PROCESS p2;

END RST_IS_DFLP_rtl;
