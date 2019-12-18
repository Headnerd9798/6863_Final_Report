LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY OPR_NR_UEOP IS
    PORT 
    (
        port_a : IN std_logic_vector (3 DOWNTO 0);
        port_b : IN std_logic_vector (1 DOWNTO 0);
        port_c : OUT std_logic_vector (3 DOWNTO 0);
        port_d : OUT std_logic_vector (3 DOWNTO 0)
    );
END OPR_NR_UEOP;

ARCHITECTURE OPR_NR_UEOP_rtl OF OPR_NR_UEOP IS
BEGIN
    port_c <= port_a AND port_b;
    port_d <= port_a OR port_b;
END OPR_NR_UEOP_rtl;
