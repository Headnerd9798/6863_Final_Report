LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SIG_NO_HIER IS
    PORT 
    (
        port_a : IN std_logic;
        port_b : IN std_logic;
        clk    : IN std_logic;
        rst    : IN std_logic;
        port_c : OUT std_logic;
        port_d : OUT std_logic
    );
END SIG_NO_HIER;

ARCHITECTURE SIG_NO_HIER_rtl OF SIG_NO_HIER IS
    COMPONENT test IS
        PORT 
        (
            port_a : IN std_logic;
            port_b : IN std_logic;
            port_c : OUT std_logic
        );
    END COMPONENT;
BEGIN
    test1 : test PORT MAP(port_a => port_a, port_b => port_b, port_c => port_d);
    PROCESS (clk, rst)
    BEGIN
        IF rst = '0' THEN
            port_c <= '0';
        ELSIF clk = '1' AND clk'EVENT THEN
            port_c <= << SIGNAL .SIG_NO_HIER.test1.port_a : std_logic >> ;
        END IF;
    END PROCESS;
END SIG_NO_HIER_rtl;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test IS
    PORT 
    (
        port_a : IN std_logic;
        port_b : IN std_logic;
        port_c : OUT std_logic
    );
END test;

ARCHITECTURE test_rtl OF test IS
BEGIN
    port_c <= port_a AND port_b;
END test_rtl;
