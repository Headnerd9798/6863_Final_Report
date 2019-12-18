LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY INP_UC_INST IS
    PORT 
    (
        port_a, port_c : IN std_logic;
        port_b         : OUT std_logic
    );
END INP_UC_INST;

ARCHITECTURE INP_US_INST_rtl OF INP_UC_INST IS
    SIGNAL sig_b : std_logic;
    COMPONENT bottom IS
        PORT 
        (
            port_a : IN std_logic;
            port_c : IN std_logic;
            port_b : OUT std_logic
        );
    END COMPONENT;

BEGIN
    bottom1 : bottom
    PORT MAP(port_a => port_a, port_b => sig_b, port_c => port_c);
END INP_US_INST_rtl;
