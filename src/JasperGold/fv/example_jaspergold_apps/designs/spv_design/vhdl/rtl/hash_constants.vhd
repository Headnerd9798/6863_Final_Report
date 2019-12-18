library ieee;
use ieee.std_logic_1164.all;

package hash_constants is

  constant ADDR_CUSTOM_KEY: std_logic_vector(11 downto 0) := X"400";
  constant ADDR_KEY_SELECT: std_logic_vector(11 downto 0) := X"401";
  constant ADDR_OTP_PROG: std_logic_vector(11 downto 0) := X"402";

  constant ADDR_HASH_ADDR: std_logic_vector(11 downto 0) := X"800";
  constant ADDR_HASH_EXPECTED: std_logic_vector(11 downto 0) := X"801";
  constant ADDR_HASH_DATA: std_logic_vector(11 downto 0) := X"802";
  constant ADDR_HASH_START: std_logic_vector(11 downto 0) := X"803";
  constant ADDR_HASH_CLEAR: std_logic_vector(11 downto 0) := X"804";
  constant ADDR_HASH_STATUS: std_logic_vector(11 downto 0) := X"805";

  constant HASH_STATUS_BUSY: std_logic_vector(31 downto 0) := X"0000_0001";
  constant HASH_STATUS_PASS: std_logic_vector(31 downto 0) := X"0000_0010";
  constant HASH_STATUS_FAIL: std_logic_vector(31 downto 0) := X"0000_1111";

  constant KEY_SELECT_CUSTOM: std_logic := '0';
  constant KEY_SELECT_OTP: std_logic := '1';
  
  constant FIX1: boolean := FALSE;
  constant FIX2: boolean := FALSE;
  
end hash_constants;

