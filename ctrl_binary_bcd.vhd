LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use WORK.all;


ENTITY ctrl_binary_bcd IS
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
	
END ctrl_binary_bcd;

ARCHITECTURE beh OF ctrl_binary_bcd IS
SIGNAL bits_buffer : std_logic_vector (bits -1 downto 0);

BEGIN
		
		
	process(BCD_overflow,busy_dect,clk)
		begin
			if(clk'event and clk = '1')	THEN
				if(bits_buffer /= bits_in) then
					bits_buffer <= bits_in;
					EN_trandcode <= '1';
				else
					EN_trandcode <= '0';
				end if;
				
				

			end if;
		-- if(busy_dect = '0') THEN
		-- 		bits_out <= bits_in;
		-- 		EN_trandcode <= '1';
		-- else
		-- 		EN_trandcode <= '0';
		-- end if;
		

		if(BCD_overflow /= (BCD_overflow'range =>'0')) THEN
		
			flag_overflow_bcd <= '1';
		else
			flag_overflow_bcd <= '0';
		end if;
	end process;
	
	
END beh;
