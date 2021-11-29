LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.MATH_REAL.ALL;
use WORK.all;

ENTITY SYSTEM_COMPLETE IS

generic (constant chiffire_deci : natural := natural(ceil(real(0.30103) * real( 16 ))) );

port(
		CLK50,Raz : IN std_logic;
		N : IN std_logic_vector(7 downto 0);
		unite	: OUT	std_logic_vector(6 downto 0);
		dizaine	: OUT	std_logic_vector(6 downto 0);
		cent	: OUT	std_logic_vector(6 downto 0);
		mille	: OUT	std_logic_vector(6 downto 0);
		Overflow : OUT std_logic;
		Overflow_BCD : OUT std_logic; 
		TxD	: out std_logic;
		choix_baud : IN std_logic;
		parity_config : IN std_logic_vector(1 downto 0)
		);


END SYSTEM_COMPLETE;
ARCHITECTURE structure OF SYSTEM_COMPLETE IS

SIGNAL data_bcd_sgn : std_logic_vector ((4 * chiffire_deci)-1 downto 0);
SIGNAL busy_bcd_sgn : std_logic;
SIGNAL Overflow_fibo_sgn : std_logic;


Component IO_fibo_top IS
generic (constant chiffire_deci : natural := natural(ceil(real(0.30103) * real( 16 ))) );

port(
		CLK50,Raz : IN std_logic;
		N : IN std_logic_vector(7 downto 0);
		unite	: OUT	std_logic_vector(6 downto 0);
		dizaine	: OUT	std_logic_vector(6 downto 0);
		cent	: OUT	std_logic_vector(6 downto 0);
		mille	: OUT	std_logic_vector(6 downto 0);
		data_bcd : OUT std_logic_vector ((4 * chiffire_deci)-1 downto 0);
		Overflow : OUT std_logic;
		Overflow_BCD : OUT std_logic;
		busy_bcd: out std_logic 
		);
END component;

component module_tout_usart IS

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
END component;

begin

	Overflow <= Overflow_fibo_sgn;
	IO_fibo_top_0 : IO_fibo_top port map (CLK50,Raz,N,unite,dizaine,cent,mille,data_bcd_sgn,Overflow_fibo_sgn,Overflow_BCD,busy_bcd_sgn);
	module_tout_usart_0 : module_tout_usart port map(data_bcd_sgn & X"000",CLK50,busy_bcd_sgn,Raz,TxD,choix_baud,Overflow_fibo_sgn,parity_config);







END structure;
