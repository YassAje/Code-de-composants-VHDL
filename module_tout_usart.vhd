LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use WORK.all;

ENTITY module_tout_usart IS

	GENERIC(constant length_buffer : integer := 32;
	constant length_DataIn_tx		:	natural		:= 8);
	
	port(	data_in : in std_logic_vector (length_buffer-1 downto 0);
			clk : IN std_logic;
			busy_dect_bcd : In std_logic;
			raz_n : In std_logic;
			TxD	: out std_logic;
			choix_baud : IN std_logic;
			Overflow_fibo : In std_logic;
			parity_config : IN std_logic_vector(1 downto 0)
			
			);
END module_tout_usart;
ARCHITECTURE structure OF module_tout_usart IS
SIGNAL	data_in_tx_usart_sgn	: std_logic_vector(length_DataIn_tx-1 downto 0 ); 
SIGNAL  usart_tx_en_sgn			: std_logic;
SIGNAL  Busy_usart_txd_sgn		: std_logic;

COMPONENT buffer_usart_tx IS

	GENERIC(constant length_buffer : integer := 32;
	constant length_DataIn_tx		:	natural		:= 8);
	
	port(	data_in : in std_logic_vector (length_buffer-1 downto 0);
			data_out: out std_logic_vector(length_DataIn_tx-1 downto 0);
			usart_tx_en : out std_logic;
			clk : IN std_logic;
			busy_dect_usart_tx : IN std_logic;
			busy_dect_bcd : In std_logic;
			raz_n : In std_logic;
			Overflow_fibo : In std_logic
			);
END COMPONENT;

COMPONENT module_usart_tx IS

GENERIC(constant length_DataIn		:	natural		:= 8);

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


END COMPONENT;

begin
	buffer_0 : buffer_usart_tx PORT MAP(data_in,data_in_tx_usart_sgn,usart_tx_en_sgn,clk,Busy_usart_txd_sgn,busy_dect_bcd,raz_n,Overflow_fibo);
	usart_0  : module_usart_tx PORT MAP('1',usart_tx_en_sgn,clk,raz_n,TxD,Busy_usart_txd_sgn,choix_baud,data_in_tx_usart_sgn,parity_config);



end structure;
