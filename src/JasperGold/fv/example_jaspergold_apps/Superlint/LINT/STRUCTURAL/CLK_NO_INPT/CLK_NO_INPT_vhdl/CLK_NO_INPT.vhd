LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CLK_NO_INPT IS
    PORT 
    (
        clk    : IN std_logic;
        reset  : IN std_logic;
        port_a : IN std_logic;
        port_b : OUT std_logic
    );
END CLK_NO_INPT;

ARCHITECTURE CLK_NO_INPT_rtl OF CLK_NO_INPT IS
    SIGNAL clk_var : std_logic;
BEGIN
    clk_var <= clk;
    PROCESS (clk_var, reset)
    BEGIN
        IF reset = '1' THEN
            port_b <= '0';
        ELSIF clk_var = '1' AND clk_var'EVENT THEN
            port_b <= port_a;
        END IF;
    END PROCESS;
END CLK_NO_INPT_rtl;
