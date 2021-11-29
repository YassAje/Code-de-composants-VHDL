LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY count1 IS
Port (  
  	clk,clear,up_down: IN std_logic;
	load : IN std_logic;
	load_data : IN std_logic_vector(7 downto 0):="01010100";
	load_data1 : IN integer range 0 to 255:= 84;
	qc1 : OUT integer range 0 to 255;
  	 qc : OUT std_logic_vector(7 downto 0)
 	);
 END count1;

ARCHITECTURE behavioral OF count1 IS

signal cnt : std_logic_vector(7 downto 0);
BEGIN
	PROCESS (clk,clear)
	
	VARIABLE cnt1 : INTEGER RANGE 0 TO 255;
	
	BEGIN

		--IF cnt <= "1111111" THEN
				--cnt <= "00000000";
				--END IF;

			--IF cnt1 = 255 THEN
				--cnt1=0;
			--END IF;
			---IF cnt1 = 0 THEN
				--cnt1:=255;
			--END IF;
	IF (clear='0') THEN
		--
		cnt<=(others=>'0');
		cnt1:= 0;
	ELSE IF (clear = '1' AND load='0') THEN
 	--	cnt <= (others => '0');

		cnt <= load_data; 
		cnt1:= load_data1;

		ELSE IF (clk'EVENT AND clk = '1') THEN
			
			IF (up_down ='1') THEN
			cnt <= cnt + "00000001"; 
			cnt1 := cnt1 + 1;
			IF cnt = "11111111" THEN
			cnt <= "00000000";
			END IF;
			IF cnt1 = 255 THEN
				cnt1:=0;
			END IF;
			

			ELSE 
			cnt <= cnt -"00000001";
			cnt1 := cnt1 - 1;
			IF cnt1 = 0 THEN
			cnt1:=255;		
			END IF;
			IF cnt <= "00000000" THEN
				cnt <= "11111111";
				END IF;
			
	END IF;
	END IF;
	END IF;
	END IF;
		
		
		qc<= cnt; 
		qc1<= cnt1;


		

	END PROCESS;
END behavioral;