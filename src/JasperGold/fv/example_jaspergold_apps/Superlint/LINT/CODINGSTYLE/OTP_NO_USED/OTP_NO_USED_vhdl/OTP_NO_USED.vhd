LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY OTP_NO_USED IS
    PORT 
    (
        port_a : IN std_logic;
        port_b : IN std_logic;
        port_c : OUT std_logic;
        port_d : OUT std_logic
    );
END OTP_NO_USED;

ARCHITECTURE OTP_NO_USED_rtl OF OTP_NO_USED IS
BEGIN
    PROCESS (port_a, port_b)
    BEGIN
        CASE port_a IS
            WHEN '1' => port_d    <= port_b;
            WHEN OTHERS => port_d <= port_a AND port_b;
        END CASE;
    END PROCESS;
END OTP_NO_USED_rtl;
