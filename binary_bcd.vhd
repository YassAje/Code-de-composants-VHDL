LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.MATH_REAL.ALL;

use WORK.all;
ENTITY binary_bcd IS
 
	generic (constant  bits : natural := 16 ;
	constant chiffire_deci : natural := natural(ceil(real(0.30103) * real( 16 ))) );
	
	port(
	binary_in : In std_logic_vector (bits-1 downto 0);
	BCD_out : OUT std_logic_vector ((4 * chiffire_deci)-1 downto 0);
	En  : In  std_logic;
	BUSY : out std_logic;
	reset_asyn : In std_logic;
	clk : In std_logic 
	);
	
END binary_bcd;

ARCHITECTURE beh OF binary_bcd IS

TYPE	machine_a_etat IS(idle, shift_bit, add_3);
SIGNAL	etat_actuel     		:  machine_a_etat;	
SIGNAL	BCD_reg 				:  std_logic_vector ((4 * chiffire_deci)-1 downto 0);
SIGNAL	binary_reg				:  std_logic_vector (bits-1 downto 0);
SIGNAL  reg_ctrl_add3			:  std_logic_vector  (chiffire_deci -1 downto 0);

--COMPONENT decteur_sup_4 IS
--	
--port(
--		BCD_a_tester : In std_logic_vector (3 downto 0);
--		flag_sup_4   : OUT std_logic
--);
--
--END COMPONENT;


Begin

process(clk,reset_asyn)
	variable cnt_bit_deglagee : integer range 0 to bits + 1 := 0;
	variable add_3_slack : std_logic :='0';
	begin

		IF(reset_asyn = '0') THEN
			cnt_bit_deglagee := 0;
			BCD_out <= (others => '0');
			BUSY <= '1';


		ELSIF(clk'EVENT AND clk = '1') THEN		--system clock rising edge
			CASE etat_actuel IS
			
			WHEN idle =>							--idle state
					
					if(EN = '1') THEN

						binary_reg <= binary_in;
						BUSY <= '1';
						etat_actuel <= shift_bit;
					else
						BUSY <= '0';
						
					end if;
					BCD_reg <= (others => '0');

			WHEN shift_bit =>
			
					if(cnt_bit_deglagee < bits) THEN
				
						if((reg_ctrl_add3 /= (reg_ctrl_add3'range => '0')) AND (add_3_slack = '0')) THEN
				
							etat_actuel <= add_3;

						else --convert state

							cnt_bit_deglagee := cnt_bit_deglagee + 1;
							Bcd_reg <= BCD_reg ((4 * chiffire_deci)-2 downto 0) & binary_reg(bits-1);
							binary_reg <= binary_reg((bits - 2) downto 0) & '0';
							add_3_slack :='0';

						end if;	

					else
							etat_actuel <= idle;
							cnt_bit_deglagee := 0;
							BUSY <= '0';
							BCD_out <= Bcd_reg;
						
					end if;
					
			WHEN add_3 =>
			
					FOR i IN 1 to chiffire_deci LOOP
						if(reg_ctrl_add3(i-1) ='1') THEN
								Bcd_reg(i*4 - 4) <= not(Bcd_reg(i*4 - 4));
								Bcd_reg(i*4 - 3) <= not(Bcd_reg(i*4 - 3) XOR Bcd_reg(i*4 - 4))  ;
								Bcd_reg(i*4 - 2) <=  Bcd_reg(i*4 - 1) AND Bcd_reg(i*4 - 4)  ;
								Bcd_reg(i*4 - 1) <= '1'  ;
						END if;
						if(i = reg_ctrl_add3'LENGTH) THEN
								add_3_slack :='1';
								etat_actuel <= shift_bit;
						end if;
					END LOOP;
			
			END CASE;	
		END IF;

		
end process;

	dectect_sup_4_logic: FOR i IN 1 to chiffire_deci GENERATE
		reg_ctrl_add3(i-1) <= Bcd_reg(4*i-1) OR (Bcd_reg(4*i-2) AND Bcd_reg(4*i-3)) OR (Bcd_reg(4*i-2) AND Bcd_reg(4*i-4));
	END GENERATE;

	

--  bcd_sup_4_dectect: FOR i IN 1 to chiffire_deci GENERATE
-- 		dectect_0: decteur_sup_4
-- 		PORT MAP (Bcd_reg(4*i-1 downto 4*i-4),reg_ctrl_add3(i-1)); 
--  END GENERATE;
 
--	FOR i IN 1 to chiffire_deci loop
--				if(Bcd_reg(4*i-1 downto 4*i-4) = "0101") THEN reg_ctrl_add3(i) <= '1'; 
--					
--				end if;
--	END loop;


end beh;
-- Bcd_reg(3 downto 0) <= Bcd_reg(3 downto 0) + "0011";
-- bcd(0) <= not bcd(0);	
-- bcd(1) <=   not(bcd(1) XOR bcd(0))	;						--set second register to adjusted value
-- bcd(2) <= bcd(3) AND bcd(0);			--set third register to adjusted value
-- bcd(3) <= '1';
