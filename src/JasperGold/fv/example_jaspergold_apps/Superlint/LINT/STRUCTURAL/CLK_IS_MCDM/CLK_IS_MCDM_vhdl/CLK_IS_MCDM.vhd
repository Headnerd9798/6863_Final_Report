LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CLK_IS_MCDM IS
	PORT
	(
		clock_a, clock_b, rst_n, data_in : std_logic;
		data_out                         : OUT std_logic);
END CLK_IS_MCDM;

ARCHITECTURE CLK_IS_MCDM_rtl OF CLK_IS_MCDM IS
	SIGNAL data_out_meta : std_logic;
	SIGNAL data_out_sig  : std_logic_vector (1 DOWNTO 0);
BEGIN
	data_out <= data_out_sig(1);
	P1 : PROCESS (clock_a)
	BEGIN
		IF clock_a = '1' AND clock_a'event THEN
			data_out_meta <= data_in;
		END IF;
	END PROCESS P1;

	P2 : PROCESS (clock_b, rst_n)
	BEGIN
		IF rst_n = '0' THEN
			data_out_sig <= "00";
		ELSIF clock_b = '1' AND clock_b'event THEN
			data_out_sig <= data_out_sig(0) & data_out_meta;
		END IF;
	END PROCESS P2;
END CLK_IS_MCDM_rtl;
