LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IOP_NR_UASG IS
    PORT 
    (
        port_a : INOUT std_logic;
        port_b : IN std_logic;
        port_c : IN std_logic;
        port_e : OUT std_logic
    );
END IOP_NR_UASG;

ARCHITECTURE IOP_NR_UASG_rtl OF IOP_NR_UASG IS
BEGIN
    PROCESS (port_a, port_b, port_c)
    BEGIN
        CASE port_c IS
            WHEN '1' => port_e    <= port_a;
            WHEN OTHERS => port_e <= port_b;
        END CASE;
    END PROCESS;
END IOP_NR_UASG_rtl;
