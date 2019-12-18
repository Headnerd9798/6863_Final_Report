LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RST_IS_DLAT IS
    PORT 
    (
        port_a : IN std_logic;
        clk    : IN std_logic;
        en     : IN std_logic;
        rst_a  : IN std_logic;
        port_c : OUT std_logic
    );
END RST_IS_DLAT;

ARCHITECTURE RST_IS_DLAT_rtl OF RST_IS_DLAT IS
    SIGNAL rst : std_logic;
BEGIN
    p1 : PROCESS (en, rst_a)
    BEGIN
        IF en = '1' THEN
            rst <= NOT rst_a;
        END IF;
    END PROCESS p1;

    p2 : PROCESS (clk, rst)
    BEGIN
        IF rst = '0' THEN
            port_c <= '0';
        ELSIF clk = '1' AND clk'EVENT THEN
            port_c <= port_a;
        END IF;
    END PROCESS p2;
END RST_IS_DLAT_rtl;
