LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


use WORK.all;
ENTITY mon_usart IS

GENERIC(constant length_DataIn		:	natural		:= 7
);

port(
     Baud_In : In std_logic;
     StartTr : In std_logic := '1';
     Clk : In std_logic;
	 Raz : In std_logic;
	 TxD : OUT std_logic;
	 Busy_usart_txd : OUT std_logic;
	 DataIn : In std_logic_vector(length_DataIn-1 downto 0) := "1010011";
	 parity_config : IN std_logic_vector(1 downto 0) -- bit 0: si 0 bit de parite en paire si 1 en impaire,bit 1: activation quand 1 
	 );


END mon_usart;

ARCHITECTURE beh OF mon_usart IS

TYPE	machine_a_etat IS(idle, envoyer);
SIGNAL	etat_actuel : machine_a_etat;
SIGNAL	tx_buffer   : std_logic_vector(length_DataIn + 1 + 1 downto 0);-- start bit + donnee de 8 bits + parity bit + stop bit
SIGNAL	tx_parity   : std_logic_vector(length_DataIn downto 0);

BEGIN

	process(Clk,Raz,StartTr)
		variable tx_buffer_deglagee : natural range 0 to length_DataIn + 1;
		variable TxD_var : std_logic;
		begin

			IF(Raz = '0') THEN
				Busy_usart_txd <= '1';
				etat_actuel <= idle;
				TxD <= '1';
				tx_buffer <= (others => '0');
			ELSIF(clk'EVENT AND clk = '1') THEN
				case etat_actuel is

					WHEN idle =>

						if(StartTr ='1') THEN
							etat_actuel <= envoyer;
							Busy_usart_txd <= '1';
								if(parity_config(1) = '0') THEN
									tx_buffer <= '0' & '1' & DataIn & '0'; --en cas de pas avoir bit parite , le bit 9 dans tx_buffer est juste pour completer le vector du buffer
								else
									tx_buffer <= '1' & tx_parity(length_DataIn) & DataIn & '0'; --stop bit + bit parite + bits de donnee + start bit
								end if;
							tx_buffer_deglagee := 0;
						else
							TxD_var := '1';
							Busy_usart_txd <= '0';
						end if;
						


					WHEN envoyer =>	
						 IF(Baud_In = '1') THEN
							
						 		
								tx_buffer <= '1' & tx_buffer(tx_buffer'left downto 1 );	
								tx_buffer_deglagee := tx_buffer_deglagee + 1;
								TxD_var := tx_buffer(0);
								
								if(parity_config(1) = '0') THEN
									if(tx_buffer_deglagee > length_DataIn + 1  ) THEN

										etat_actuel <= idle;
										Busy_usart_txd <= '0';
										
									end if;
								else
									if(tx_buffer_deglagee > length_DataIn + 1 + 1  ) THEN

										etat_actuel <= idle;
										Busy_usart_txd <= '0';
										
									end if;
								end if;
									

						 end if;


				end case;
					
				TxD <= TxD_var;

			end if;

	end process;
	


	tx_parity(0) <= parity_config (0);
	tx_parity_logic: FOR i IN 0 to length_DataIn-1 GENERATE
		tx_parity(i+1) <= tx_parity(i) XOR DataIn(i);
	END GENERATE;


end beh;

