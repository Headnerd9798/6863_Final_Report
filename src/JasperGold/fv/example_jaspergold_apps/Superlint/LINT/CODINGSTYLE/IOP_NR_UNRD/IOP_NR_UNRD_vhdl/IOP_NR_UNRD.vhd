LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IOP_NR_UNRD IS
    PORT 
    (
        port_a : INOUT std_logic;
        port_b : IN std_logic;
        port_C : IN std_logic
    );
END IOP_NR_UNRD;

ARCHITECTURE IOP_NR_UNRD_rtl OF IOP_NR_UNRD IS
BEGIN
    port_a <= port_b AND port_c;
END IOP_NR_UNRD_rtl;
