library ieee;
use ieee.std_logic_1164.all;

entity eMux32 is
	port(
		pIn0		: in std_logic_vector(31 downto 0);
		pIn1		: in std_logic_vector(31 downto 0);
		pSelect		: in std_logic;
		pOut		: out std_logic_vector(31 downto 0)
	);
end eMux32;

architecture logic of eMux32 is
begin
	process(pSelect)
	begin
		if pSelect='0' then
			pOut <= pIn0;
		else
			pOut <= pIn1;
		end if;
	end process;
end logic;