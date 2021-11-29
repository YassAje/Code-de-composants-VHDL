LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY decompteur IS

	port(
	CLK,EN, raz, reload: IN std_logic;
	Sequence_nombre : OUT std_logic_vector (3 downto 0);
	alarme : OUT std_logic
	);
END decompteur;

ARCHITECTURE beh OF decompteur IS

signal cnt : std_logic_vector (3 downto 0) := "1111";
variable init_t : std_logic;

BEGIN
	
	PROCESS (CLK,EN, raz, cnt)
	
	
	
	BEGIN
			IF(CLK'EVENT AND CLK = '1') THEN
			IF ( raz = '0' ) then
			cnt <= "1111";
			init_t :='0';
					
					
			
				
					init_t := '0';
				ELSIF (EN = '1') THEN
					
					cnt <= cnt - 1;
				

						IF(cnt = 0) THEN
							init_t := '1';
							
						else
							IF (reload = '1') then 
							cnt <= "1111";
							init_t := '0';
								
						END IF;
						

				END IF;
				
			END IF;
			end if;
			
			
			
		Sequence_nombre <= cnt;
		alarme <= init_t;
		
			
			
			
			
	END PROCESS;
END beh;