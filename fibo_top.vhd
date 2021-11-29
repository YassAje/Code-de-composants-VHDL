LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.MATH_REAL.ALL;
use WORK.all;

ENTITY fibo_top IS
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
END fibo_top;

ARCHITECTURE structure OF fibo_top IS

SIGNAL	data : std_logic_vector(15 downto 0);
SIGNAL	data2 : std_logic_vector(15 downto 0);
SIGNAL	data_bcd_sgn : std_logic_vector(19 downto 0);
SIGNAL  EN_bin_bcd : std_logic;
SIGNAL  BUSY_bin_bcd : std_logic;


COMPONENT	g_fibonacci

GENERIC(M : integer := 16);
	port(
	CLK,EN,Raz : IN std_logic;
	N : IN std_logic_vector(7 downto 0);
	Overflow : OUT std_logic;
	Sequence_nombre : OUT std_logic_vector (M-1 downto 0)
	);
END COMPONENT;

COMPONENT	SEG_7

port(in4: in std_logic_vector (3 downto 0);
			seg7: out std_logic_vector(0 to 6)
			);
			
END COMPONENT;

COMPONENT binary_bcd IS

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
	
			
END COMPONENT;

COMPONENT	ctrl_binary_bcd IS
generic (constant  bits : natural := 16) ;
	
	
port(
	BCD_overflow : In std_logic_vector (3 downto 0);
	bits_in      : in std_logic_vector  (bits -1 downto 0);
	bits_out      : buffer std_logic_vector  (bits -1 downto 0);
	EN_trandcode  : buffer std_logic;
	busy_dect     : In  std_logic;
	flag_overflow_bcd   : OUT std_logic;
	clk			  : in std_logic
);
END COMPONENT;



BEGIN
	data_bcd <= data_bcd_sgn;
	busy_bcd <= BUSY_bin_bcd;
	fib1 : g_fibonacci PORT MAP(CLK,EN,Raz,N,Overflow,data);
	dec_0 : SEG_7 PORT MAP(data_bcd_sgn(3 downto 0),unite);
	dec_1 : SEG_7 PORT MAP(data_bcd_sgn(7 downto 4),dizaine);
	dec_2 : SEG_7 PORT MAP(data_bcd_sgn(11 downto 8),cent);
	dec_3 : SEG_7 PORT MAP(data_bcd_sgn(15 downto 12),mille);
	bin_bcd_0 : binary_bcd PORT MAP(data,data_bcd_sgn,EN_bin_bcd,BUSY_bin_bcd,Raz,CLK);
	ctrl_bin_bcd_0 : ctrl_binary_bcd PORT MAP (data_bcd_sgn(19 downto 16),data,data2,EN_bin_bcd,BUSY_bin_bcd,Overflow_BCD,clk);
END structure;
