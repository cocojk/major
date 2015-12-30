library ieee;
use ieee.std_logic_1164.all;

entity eJMux is
	port(
		pNPC		: in std_logic_vector(31 downto 0);
		pJPC		: in std_logic_vector(25 downto 0);
		pSelect		: in std_logic;
		pOut		: out std_logic_vector(31 downto 0)
	);
end eJMux;

architecture logic of eJMux is
begin
	process(pSelect)
	begin
		if pSelect='0' then
			pOut <= pNPC;
		else
			pOut(27 downto 2) <= pJPC;
			pOut(31)<='0';
			pOut(30)<='0';
			pOut(29)<='0';
			pOut(28)<='0';
			pOut(1)<='0';
			pOut(0)<='0';
		end if;
	end process;
end logic;