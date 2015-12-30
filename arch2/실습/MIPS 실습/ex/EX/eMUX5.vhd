library ieee;
use ieee.std_logic_1164.all;

entity eMUX5 is
	port(
		pIn0		: in std_logic_vector(4 downto 0);
		pIn1		: in std_logic_vector(4 downto 0);
		pSelect		: in std_logic;
		pOut		: out std_logic_vector(4 downto 0)
	);
end eMUX5;

architecture logic of eMUX5 is
begin
	process(pSelect)
	begin
		if pSelect='1' then
			pOut <= pIn1;
		else
			pOut <= pIn0;
		end if;
	end process;
end logic;