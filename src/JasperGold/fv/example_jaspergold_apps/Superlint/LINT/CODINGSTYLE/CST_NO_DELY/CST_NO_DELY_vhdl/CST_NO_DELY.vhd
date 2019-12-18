LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CST_NO_DELY IS
    PORT 
    (
        out1 : OUT std_logic;
        data : IN std_logic
    );
END CST_NO_DELY;

ARCHITECTURE CST_NO_DELY_rtl OF CST_NO_DELY IS
    SIGNAL d1 : TIME;
BEGIN
    out1 <= data AFTER d1;
END CST_NO_DELY_rtl;
