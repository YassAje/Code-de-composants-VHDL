LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

use WORK.all;
ENTITY Baud_generateur IS

port(
    vitesse : In std_logic;
    clk : In std_logic;
    baud : Out std_logic
);


END Baud_generateur;


ARCHITECTURE beh OF Baud_generateur IS
begin


    process(clk,vitesse)
	 
    variable cnt : integer range 0 to 5208; 
	 variable baud_var : std_logic ;
    begin


        IF(clk'EVENT AND clk = '1') THEN
		  
        case vitesse is
            when '0' =>
                IF(cnt = 5208) THEN
                    cnt :=0;
                    baud_var:= '1';
                eLSE
                    baud_var:= '0';
                    cnt := cnt + 1;
            
                END IF;
            when '1' =>
                IF(cnt = 2604) THEN
                    cnt :=0;
                    baud_var:= '1';
                eLSE
                    baud_var:= '0';
                    cnt := cnt + 1;
        
                END IF;
            end case;


        end if;

	 baud <= baud_var;

    end process;




END beh;