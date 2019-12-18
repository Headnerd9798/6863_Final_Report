LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IDN_NR_SVKW IS
    PORT 
    (
        port_a     : IN std_logic;
        covergroup : OUT std_logic
    );
END IDN_NR_SVKW;

ARCHITECTURE IDN_NR_SVKW_rtl OF IDN_NR_SVKW IS
BEGIN
    covergroup <= port_a;
END IDN_NR_SVKW_rtl;
