library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity eIF is
	port(
		pNextpc			:in std_logic_vector(31 downto 0);
		pIncpc			:out std_logic_vector(31 downto 0);
		pInstruction	:out std_logic_vector(31 downto 0);
		pJPC			:in std_logic_vector(25 downto 0);
		pJSelect		:in std_logic;
		pSelect			:in std_logic;
		pReset			:in std_logic;
		pClock			:in std_logic
	);
end eIF;

architecture behavior of eIF is
	signal sInstruction:std_logic_vector(31 downto 0);
component eMux32
	port(
		pIn0		: in std_logic_vector(31 downto 0);
		pIn1		: in std_logic_vector(31 downto 0);
		pSelect		: in std_logic;
		pOut		: out std_logic_vector(31 downto 0)
	);
end component;
component eAdd4
	port (
		pIn			: in	std_logic_vector(31 downto 0);
		pOut		: out	std_logic_vector(31 downto 0)
	);
end component;
component ePC
	port(
		pIn		:in std_logic_vector(31 downto 0);
		pOut	:out std_logic_vector(31 downto 0);
		pReset	:in std_logic;
		pClock	:in std_logic
	);
end component;
component eImem
	port (
		pReadaddr	: in	std_logic_vector(31 downto 0);
		pDataout	: out	std_logic_vector(31 downto 0);
		pClock		: in	std_logic
	);
end component;
component eJmux
	port(
		pNPC		: in std_logic_vector(31 downto 0);
		pJPC		: in std_logic_vector(25 downto 0);
		pSelect		: in std_logic;
		pOut		: out std_logic_vector(31 downto 0)
	);
end component;
	signal sNpc:std_logic_vector(31 downto 0);
	signal sCpc:std_logic_vector(31 downto 0);
	signal sIpc:std_logic_vector(31 downto 0);
	signal sJpc:std_logic_vector(31 downto 0);
begin
	pIncpc<=sCpc;
	
	process(pReset,sInstruction)
	begin
		if pReset='1' then
			pInstruction<=X"FFFFFFFF";
		else
			pInstruction<=sInstruction;
		end if;
	end process;

	cPC:ePC port map(sNpc,sCpc,pReset,not pClock);
	cimem:eImem port map(sCpc,sInstruction,pClock);
	cadd4:eAdd4 port map(sCpc,sIpc);
	cmux:eMux32 port map(sJpc,pNextpc,pSelect,sNpc);
	cjmux:eJmux port map(sIpc,pJPC,pJSelect,sJpc);
end behavior;