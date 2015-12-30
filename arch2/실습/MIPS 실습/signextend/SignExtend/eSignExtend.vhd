library ieee;
use ieee.std_logic_1164.all;

entity eSignExtend is
	port(
		pIn			:in std_logic_vector(15 downto 0);
		pOut		:out std_logic_vector(31 downto 0)
	);
end eSignExtend;

architecture logic of eSignExtend is
begin
	pOut(14 downto 0) <= pIn(14 downto 0);
	process(pIn)
	begin
		for n in 15 to 31 loop
			pOut(n) <= pIn(15);
		end loop;
	end process;
end logic;