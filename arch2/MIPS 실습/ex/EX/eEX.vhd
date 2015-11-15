library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity eEX is
	port(
		pControl_in		:in std_logic_vector(7 downto 0);
		pData1			:in std_logic_vector(31 downto 0);
		pData2			:in std_logic_vector(31 downto 0);
		pImm			:in std_logic_vector(31 downto 0);
		pRT				:in std_logic_vector(4 downto 0);
		pRD				:in std_logic_vector(4 downto 0);
		
		pControl_out	:out std_logic_vector(3 downto 0);
		pBranch			:out std_logic;
		pResult			:out std_logic_vector(31 downto 0);
		pWriteData		:out std_logic_vector(31 downto 0);
		pWriteReg		:out std_logic_vector(4 downto 0)
	);
end eEX;

architecture behavior of eEX is
	signal sALUin2:std_logic_vector(31 downto 0);
component eMUX5
	port(
		pIn0		: in std_logic_vector(4 downto 0);
		pIn1		: in std_logic_vector(4 downto 0);
		pSelect		: in std_logic;
		pOut		: out std_logic_vector(4 downto 0)
	);
end component;
component eMUX32
	port(
		pIn0		: in std_logic_vector(31 downto 0);
		pIn1		: in std_logic_vector(31 downto 0);
		pSelect		: in std_logic;
		pOut		: out std_logic_vector(31 downto 0)
	);
end component;
component eALU
	port(
		pOperator		:in std_logic_vector(5 downto 0);
		pOperation		:in std_logic;
		pBranch			:in std_logic;
		pIn1			:in std_logic_vector(31 downto 0);
		pIn2			:in std_logic_vector(31 downto 0);
		pBranch_out		:out std_logic;
		pOut			:out std_logic_vector(31 downto 0)
	);
end component;
begin
	pControl_out<=pControl_in(7 downto 4);
	pWriteData<=pData2;

	cMUX5:eMUX5 port map(pRT,pRD,pControl_in(0),pWriteReg);
	cMUX32:eMUX32 port map(pData2,pImm,pControl_in(2),sALUin2);
	cALU:eALU port map(pImm(5 downto 0),pControl_in(1),pControl_in(3),pData1,sALUin2,pBranch,pResult);
end behavior;