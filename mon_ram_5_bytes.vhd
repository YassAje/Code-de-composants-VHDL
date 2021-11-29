LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use WORK.all;

ENTITY mon_ram_5_bytes IS
	GENERIC(m_longeur : integer := 8);
	port(	data_in_ram : in std_logic_vector (m_longeur-1 downto 0);
			ram_address : in std_logic_vector(3 downto 0);
			data_out_ram: out std_logic_vector(m_longeur-1 downto 0);
			write_en : IN std_logic;
			clk : IN std_logic

			);

END mon_ram_5_bytes;
ARCHITECTURE beh OF mon_ram_5_bytes IS

type memoire_type is array (4 downto 0) of std_logic_vector(m_longeur -1 downto 0);
signal memoire : memoire_type;

begin
		process(clk)
		begin
			IF(clk'EVENT AND clk = '1') THEN
				if(write_en = '1') THEN
					memoire(to_integer(unsigned(ram_address))) <= data_in_ram;
				end if;
			end if;
		
		end process;

	data_out_ram <= memoire(to_integer(unsigned(ram_address)));

end beh;
