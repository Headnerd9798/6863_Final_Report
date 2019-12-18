LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CLK_NS_EDMX IS
    PORT 
    (
        clk    : IN std_logic;
        port_a : IN std_logic;
        port_b : OUT std_logic;
        port_c : OUT std_logic
    );
END CLK_NS_EDMX;

ARCHITECTURE CLK_NS_EDMX_rtl OF CLK_NS_EDMX IS
BEGIN
    p1 : PROCESS (clk)
    BEGIN
        IF clk = '1' AND clk'EVENT THEN
            port_b <= port_a;
        END IF;
    END PROCESS p1;

    p2 : PROCESS (clk)
    BEGIN
        IF clk = '0' AND clk'EVENT THEN
            port_c <= NOT port_a;
        END IF;
    END PROCESS p2;

END CLK_NS_EDMX_rtl;
