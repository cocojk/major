library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity eAdd4 is
	port (
		pIn			: in	std_logic_vector(31 downto 0);
		pOut		: out	std_logic_vector(31 downto 0)
	);
end eAdd4;

architecture behavior of eAdd4 is
begin
	process(pIn)
	begin
		pOut <= pIn +4;
	end process;
end behavior;
