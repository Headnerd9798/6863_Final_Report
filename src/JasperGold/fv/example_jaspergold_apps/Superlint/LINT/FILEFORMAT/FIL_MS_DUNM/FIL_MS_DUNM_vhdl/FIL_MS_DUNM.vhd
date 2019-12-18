LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FIL_MS_DUNM_test IS
    PORT 
    (
        port_a : IN std_logic;
        port_b : IN std_logic;
        port_c : OUT std_logic
    );
END FIL_MS_DUNM_test;

ARCHITECTURE FIL_MS_DUNM_test_rtl OF FIL_MS_DUNM_test IS
BEGIN
    port_c <= port_a AND port_b;
END FIL_MS_DUNM_test_rtl;
