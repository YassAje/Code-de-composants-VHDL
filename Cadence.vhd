LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use WORK.all;

ENTITY Cadence IS

	port(
	CLK,Raz : IN std_logic;
	Sortie : OUT std_logic
	);
END Cadence;
ARCHITECTURE beh OF Cadence IS
BEGIN

process(CLK,Raz)
	variable cnt : integer range 0 to 25000000; 
	variable mon_out : std_logic;
	begin

		IF(clk'EVENT AND clk = '0') THEN
		
    				
				IF(cnt = 25000000) THEN
					cnt :=0;
					mon_out:= '1';
				ELSE
					cnt := cnt + 1;
					mon_out:= '0';
				END IF;
				
		END IF;
			
			
		IF (Raz = '0') THEN	
				cnt := 0;
		END IF;
		
		Sortie <= mon_out;
		
	end process;




END beh ;