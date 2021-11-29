LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.MATH_REAL.ALL;
use WORK.all;

ENTITY IO_fibo_top IS
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
END IO_fibo_top;

ARCHITECTURE structure OF IO_fibo_top IS

SIGNAL	sortie0 : std_logic;

COMPONENT	fibo_top
generic (constant chiffire_deci : natural := natural(ceil(real(0.30103) * real( 16 ))) );
	port(
	CLK,EN,Raz : IN std_logic;
	N : IN std_logic_vector(7 downto 0);
	unite	: OUT	std_logic_vector(6 downto 0);
	dizaine	: OUT	std_logic_vector(6 downto 0);
	cent	: OUT	std_logic_vector(6 downto 0);
	mille	: OUT	std_logic_vector(6 downto 0);
	Overflow : OUT std_logic;
	data_bcd : OUT std_logic_vector ((4 * chiffire_deci)-1 downto 0);
	Overflow_BCD : OUT std_logic;
	busy_bcd: out std_logic 
	);
END COMPONENT;

COMPONENT	Cadence

	port(
	CLK,Raz : IN std_logic;
	Sortie : OUT std_logic
	);
END COMPONENT;

BEGIN
	cad0 : Cadence PORT MAP(CLK50,Raz,sortie0);
	top0 : fibo_top PORT MAP(CLK50,sortie0,Raz,N,unite,dizaine,cent,mille,Overflow,data_bcd,Overflow_BCD,busy_bcd);
END structure;