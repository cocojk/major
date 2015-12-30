library ieee;
use ieee.std_logic_1164.all;

entity ePC is
	port(
		pIn		:in std_logic_vector(31 downto 0);
		pOut	:out std_logic_vector(31 downto 0);
		pReset	:in std_logic;
		pClock	:in std_logic
	);
end ePC;

architecture behavior of ePC is
begin
	process
	begin
		wait until pClock'event and pClock='1';
		if pReset='0' then
			pOut<=pIn;
		elsif pReset='1' then
			pOut<=X"00000000";
		end if;
	end process;
end behavior;