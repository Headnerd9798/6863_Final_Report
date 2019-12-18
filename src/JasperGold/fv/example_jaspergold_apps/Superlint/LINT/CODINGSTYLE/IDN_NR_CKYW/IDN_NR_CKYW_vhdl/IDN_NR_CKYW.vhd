LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IDN_NR_CKYW IS
    PORT 
    (
        delete       : IN std_logic;
        dynamic_cast : IN std_logic;
        explicit     : IN std_logic;
        double       : OUT std_logic
    );
END IDN_NR_CKYW;

ARCHITECTURE IDN_NR_CKYW_rtl OF IDN_NR_CKYW IS
BEGIN
    double <= (delete AND (dynamic_cast OR explicit));
END IDN_NR_CKYW_rtl;
