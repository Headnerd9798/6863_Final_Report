LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ASG_MS_RPAD IS
    PORT 
    (
        port_a : IN std_logic_vector(3 DOWNTO 0);
        port_c : OUT std_logic_vector(5 DOWNTO 0)
    );
END ASG_MS_RPAD;

ARCHITECTURE ASG_MS_RPAD_rtl OF ASG_MS_RPAD IS
BEGIN
    PROCESS (port_a)
    BEGIN
        port_c <= port_a;
    END PROCESS;
END ASG_MS_RPAD_rtl;
