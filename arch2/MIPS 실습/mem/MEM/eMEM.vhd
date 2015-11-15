library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity eMEM is
	port(
		pControl_in		:in std_logic_vector(3 downto 0);
		pAddress		:in std_logic_vector(31 downto 0);
		pWriteData		:in std_logic_vector(31 downto 0);
		pWriteReg_in	:in std_logic_vector(4 downto 0);

		pControl_out	:out std_logic_vector(1 downto 0);
		pReadData		:out std_logic_vector(31 downto 0);
		pResult			:out std_logic_vector(31 downto 0);
		pWriteReg_out	:out std_logic_vector(4 downto 0);

		pClock			:in std_logic
	);
end eMEM;

architecture behavior of eMEM is
component eDmem
	port(
		pAddress		:in		std_logic_vector(7 downto 0);
		pWriteData		:in		std_logic_vector(31 downto 0);
		pOE				:in		std_logic;
		pWE				:in		std_logic;
		pReadData		:out	std_logic_vector(31 downto 0);
		pClock			:in		std_logic
	);
end component;
begin
	pControl_out<=pControl_in(3 downto 2);
	pResult<=pAddress;
	pWriteReg_out<=pWriteReg_in;

	cDmem:eDmem port map(pAddress(9 downto 2),pWriteData,pControl_in(0),pControl_in(1),pReadData,pClock);
end behavior;