LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bottom IS
    PORT 
    (
        port_a : IN std_logic;
        port_c : IN std_logic;
        port_b : OUT std_logic
    );
END bottom;

ARCHITECTURE bottom_rtl OF bottom IS
    SIGNAL sig_b : std_logic;
BEGIN
    port_b <= port_a;
    sig_b  <= port_c;
END bottom_rtl;
