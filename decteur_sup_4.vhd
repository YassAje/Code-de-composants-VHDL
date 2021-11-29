LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

use WORK.all;
ENTITY decteur_sup_4 IS
	
port(
	BCD_a_tester : In std_logic_vector (3 downto 0);
	flag_sup_4   : OUT std_logic
);
	
END decteur_sup_4;

ARCHITECTURE beh OF decteur_sup_4 IS
BEGIN
flag_sup_4 <= BCD_a_tester(3) OR (BCD_a_tester(2) AND BCD_a_tester(1)) OR (BCD_a_tester(2) AND BCD_a_tester(0));


END beh;
