library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity eShiftAdder is
	port(
		pIn1	:in std_logic_vector(31 downto 0);
		pIn2	:in std_logic_vector(31 downto 0);
		pOut	:out std_logic_vector(31 downto 0)
	);
end eShiftAdder;

architecture behavior of eShiftAdder is
	signal sShift:std_logic_vector(31 downto 0);
begin
	process(pIn1,pIn2)
	begin
		for N in 0 to 29 loop
			sShift(N+2)<=pIn2(N);
		end loop;
		sShift(1)<='0';
		sShift(0)<='0';
	end process;
	
	process(pIn1,pIn2,sShift)
	begin
		pOut <= pIn1 + sShift -4;
	end process;
end behavior;