LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY OTP_NR_UDRV IS
	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
                port_a : in std_logic;
		port_b : IN std_logic_vector(1 DOWNTO 0);
		port_c : OUT std_logic_vector(1 DOWNTO 0);
		port_d : OUT std_logic);
END OTP_NR_UDRV;

ARCHITECTURE OTP_NR_UDRV_rtl OF OTP_NR_UDRV IS
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			port_c <= "00";
		ELSIF (port_a = '1') THEN
			port_c <= "01";
		ELSIF clk = '1' AND clk'event THEN
			port_c <= port_b;
		END IF;
	END PROCESS;
END OTP_NR_UDRV_rtl;
