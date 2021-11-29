LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use WORK.all;

ENTITY buffer_usart_tx IS

	GENERIC(constant length_buffer : integer := 32;
	constant length_DataIn_tx		:	natural		:= 8);
	
	port(	data_in : in std_logic_vector (length_buffer-1 downto 0);
			data_out: out std_logic_vector(length_DataIn_tx-1 downto 0);
			usart_tx_en : out std_logic;
			clk : IN std_logic;
			busy_dect_usart_tx : IN std_logic;
			busy_dect_bcd : In std_logic;
			raz_n : In std_logic;
			Overflow_fibo : In std_logic;
			busy : out std_logic
			);
END buffer_usart_tx;

ARCHITECTURE beh OF buffer_usart_tx IS

TYPE	machine_a_etat IS(idle, envoyer_tout);
SIGNAL	etat_actuel : machine_a_etat ;
SIGNAL 	buffer_usart_tx_sgn : std_logic_vector(length_buffer - 1 downto 0);
signal	busy_dect_bcd_vec :  std_logic_vector(2 downto 0);
signal	en_envoyer_tout : std_logic ;

begin
		PROCESS(clk,raz_n) -- decteteur de signal front descendant
		
		begin
			if(raz_n ='0') then
			
				en_envoyer_tout <= '0';
				
			elsif(Clk'EVENT AND Clk = '1') then -- le quartus n'aime pas la structure "if(front_montant) else", l'else ne peut pas attachee après la condition if(Clk1'EVENT AND Clk1 = '1')

				busy_dect_bcd_vec <= busy_dect_bcd_vec(busy_dect_bcd_vec'left-1 downto 0) & busy_dect_bcd;

				if(busy_dect_bcd_vec(busy_dect_bcd_vec'left downto busy_dect_bcd_vec'left -1) = "10") THEN
					en_envoyer_tout <= '1';
				else
					en_envoyer_tout <= '0';
				end if;
				
	  		 end if;
		end process;


		process(clk,raz_n)
		variable cnt_nipple_envoyee : integer range 0 to 9;
		begin
			if(raz_n = '0')then
			
					etat_actuel <= idle;
					buffer_usart_tx_sgn <= (others => '0');
					
			elsif(clk'event and clk = '1') THEN
				case etat_actuel IS 
					when idle =>
						if(en_envoyer_tout ='1') THEN
							etat_actuel <= envoyer_tout;
							buffer_usart_tx_sgn <= data_in;
							cnt_nipple_envoyee := 0;
							busy <= '1';
							
						else
							etat_actuel <= idle;
							data_out <= (others => '0');
							busy <= '0';
						end if;

					when envoyer_tout =>
						if(cnt_nipple_envoyee <= 5) THEN
							if(busy_dect_usart_tx = '0') then
								
								if(cnt_nipple_envoyee > 0) then
									data_out <= "0011" & buffer_usart_tx_sgn(buffer_usart_tx_sgn'left downto buffer_usart_tx_sgn'left -3);--transcode bcd ascii
									--buffer_usart_tx_sgn <= X"00" & buffer_usart_tx_sgn(buffer_usart_tx_sgn'left downto buffer_usart_tx_sgn'right +8) ;
								else
									if(Overflow_fibo ='0') then --premier caractere a envoyer 'E' ou 'B' en dependant l'etat de Overflow
										data_out <= X"42";
									else
										data_out <= X"45";
									end if;
								end if;
								if(cnt_nipple_envoyee > 0) then --decaler le buffer interieur un nipple vers droit 
									buffer_usart_tx_sgn <=  buffer_usart_tx_sgn(buffer_usart_tx_sgn'left-4 downto buffer_usart_tx_sgn'right ) & X"0" ;
								end if;
								cnt_nipple_envoyee := cnt_nipple_envoyee + 1;
								usart_tx_en <= '1' ;
							
							end if;
						elsif(cnt_nipple_envoyee = 6) then --7eme caractere c'est retrun
								if(busy_dect_usart_tx = '0') then
									cnt_nipple_envoyee := cnt_nipple_envoyee + 1;
									data_out <= X"0D";
									usart_tx_en <= '1' ;
								end if;
						elsif(cnt_nipple_envoyee = 7) then --8eme caractere c'est ligne nouvelle
								if(busy_dect_usart_tx = '0') then
									data_out <= X"0A";
									usart_tx_en <= '1' ;
									cnt_nipple_envoyee := cnt_nipple_envoyee + 1;
								end if;
						
						elsif(busy_dect_usart_tx = '0') then --le dernier byte a ete transfert
							cnt_nipple_envoyee := 0;
							etat_actuel <= idle;
							usart_tx_en <= '0' ; 
							busy <= '0';
						end if;
				end case;

			end if;

		
		end process;
		
		
		
		
end beh;