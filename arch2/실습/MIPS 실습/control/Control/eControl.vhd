library ieee;
use ieee.std_logic_1164.all;

entity eControl is
	port(
		pOpcode		:in std_logic_vector(5 downto 0);
		pRegWrite	:out std_logic;
		pMem2Reg	:out std_logic;
		pMemWrite	:out std_logic;
		pMemRead	:out std_logic;
		pBranch		:out std_logic;
		pALUSrc		:out std_logic;
		pALUop		:out std_logic;
		pRegDst		:out std_logic;
		pReset		:in std_logic
	);
end eControl;

architecture logic of eControl is
begin
	process(pReset,pOpcode)
	begin
		if pReset='1' then
			pRegDst<='0';
			pMem2Reg<='0';
			pBranch<='0';
			pMemRead<='0';
			pALUop<='0';
			pMemWrite<='0';
			pALUSrc<='0';
			pRegWrite<='0';
		else
			--RegDst
			if pOpcode="000000" then
				pRegDst<='1';
			else
				pRegDst<='0';
			end if;

			--Branch
			if pOpcode="000100" or pOpcode="000101" then
				pBranch<='1';
			else
				pBranch<='0';
			end if;
		
			--MemRead
			if pOpcode="100011" then
				pMem2Reg<='1';
				pMemRead<='1';
			else
				pMem2Reg<='0';
				pMemRead<='0';
			end if;
			
			--ALUop
			if pOpcode="000000" or pOpcode="000101" then
				pALUop<='1';
			else
				pALUop<='0';
			end if;
			
			--MemWrite
			if pOpcode="101011" then
				pMemWrite<='1';
			else
				pMemWrite<='0';
			end if;
			
			--ALUsrc
			if pOpcode="100011" or pOpcode="101011" then
				pALUsrc<='1';
			else
				pALUsrc<='0';
			end if;
			
			--RegWrite
			if pOpcode="000000" or pOpcode="100011" then
				pRegWrite<='1';
			else
				pRegWrite<='0';
			end if;
		end if;
	end process;
end logic;