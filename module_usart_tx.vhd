LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

use WORK.all;
ENTITY module_usart_tx IS

GENERIC(constant length_DataIn		:	natural		:= 8
);

port(

    En_usart_manuel : In std_logic;
	 En_usart : In std_logic;
    Clk1 : In std_logic;
	 Raz : In std_logic;
	 TxD : OUT std_logic;
	 Busy_usart_txd : OUT std_logic;
	 choix_baud : IN std_logic;
	 DataIn : In std_logic_vector(length_DataIn-1 downto 0);
	 parity_config : IN std_logic_vector(1 downto 0)
	 
);


END module_usart_tx;

ARCHITECTURE structure OF module_usart_tx IS

SIGNAL	baud_generee :  std_logic;	
signal	sgn_start_vec :  std_logic_vector(2 downto 0);
signal	sgn_start_en : std_logic ;

component mon_usart IS

GENERIC(constant length_DataIn		:	natural		:= 8
);
port(
     Baud_In : In std_logic;
     StartTr : In std_logic;
     Clk : In std_logic;
	 Raz : In std_logic;
	 TxD : OUT std_logic;
	 Busy_usart_txd : OUT std_logic;
	 DataIn : In std_logic_vector(length_DataIn-1 downto 0);
	 parity_config : IN std_logic_vector(1 downto 0) -- bit 0: si 0 bit de parite en paire si 1 en impaire,bit 1: activation 
	 );
END component;
component Baud_generateur IS

port(
    vitesse : In std_logic;
    clk : In std_logic;
    baud : Out std_logic
);
END component;


begin
--			process(Clk1)
--			variable cnt : natural range 0 to 50 :=0 ;
--			begin
--			
--				if(Clk1'EVENT AND Clk1 = '1') then -- le quartus n'aime pas la structure "if(front_montant) else", l'else ne peut pas attachee après la condition if(Clk1'EVENT AND Clk1 = '1')
--
--						 sgn_start_vec <= sgn_start_vec(sgn_start_vec'left-1 downto 0) & En_usart_manuel;
--
--						 if(sgn_start_vec(sgn_start_vec'left downto sgn_start_vec'left -1) = "10") THEN
--
--								sgn_start_en <= '1';
--							
--									elsif(En_usart ='1') THEN
--										
--										sgn_start_en <= '1';
--									
--									else
--									sgn_start_en <= '0';
--								
--								
--								
--								
--							end if;
--						 
--		
--				end if;
--				
--			end process;
--		

	usart_0 : mon_usart port map(baud_generee,En_usart,Clk1,Raz,TxD,Busy_usart_txd,DataIn,parity_config);
	gene_baud_0 : Baud_generateur port map(choix_baud,Clk1,baud_generee);


end structure;
