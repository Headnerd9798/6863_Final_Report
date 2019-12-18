LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IOP_NO_USED IS
    PORT 
    (
        port_a : INOUT std_logic;
        port_b : IN std_logic;
        port_c : IN std_logic;
        port_d : OUT std_logic
    );
END IOP_NO_USED;

ARCHITECTURE IOP_NO_USED_rtl OF IOP_NO_USED IS
BEGIN
    PROCESS (port_d, port_c)
    BEGIN
        CASE port_c IS
            WHEN '1' => port_d    <= port_b;
            WHEN OTHERS => port_d <= port_c;
        END CASE;
    END PROCESS;
END IOP_NO_USED_rtl;
