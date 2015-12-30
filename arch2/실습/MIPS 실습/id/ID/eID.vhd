library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity eID is
	port(
		pIncpc_in		:in std_logic_vector(31 downto 0);
		pInstruction	:in std_logic_vector(31 downto 0);
		pWriteData		:in std_logic_vector(31 downto 0);
		pWriteReg		:in std_logic_vector(4 downto 0);
		
		pControl		:out std_logic_vector(7 downto 0);
		pIncpc_out		:out std_logic_vector(31 downto 0);
		pData1			:out std_logic_vector(31 downto 0);
		pData2			:out std_logic_vector(31 downto 0);
		pImm			:out std_logic_vector(31 downto 0);
		pRT				:out std_logic_vector(4 downto 0);
		pRD				:out std_logic_vector(4 downto 0);

		pJump			:out std_logic;
		pRegWE			:in std_logic;
		pReset			:in std_logic;
		pClock			:in std_logic
	);
end eID;

architecture behavior of eID is
	signal sImm:std_logic_vector(31 downto 0);
component eSignExtend
	port(
		pIn			:in std_logic_vector(25 downto 0);
		pOut		:out std_logic_vector(31 downto 0)
	);
end component;
component eControl
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
		pJump		:out std_logic;
		pReset		:in std_logic;
		pClock		:in std_logic
	);
end component;
component eRegFile
	port(
		pReadRegister1	: in std_logic_vector(4 downto 0);
		pReadRegister2	: in std_logic_vector(4 downto 0);
		pWriteRegister	: in std_logic_vector(4 downto 0);
		pWriteData		: in std_logic_vector(31 downto 0);
		pReadData1		: out std_logic_vector(31 downto 0);
		pReadData2		: out std_logic_vector(31 downto 0);
		pRegWE			: in std_logic;
		pReset			: in std_logic;
		pClock			: in std_logic
	);
end component;
component eShiftAdder
	port(
		pIn1	:in std_logic_vector(31 downto 0);
		pIn2	:in std_logic_vector(31 downto 0);
		pOut	:out std_logic_vector(31 downto 0)
	);
end component;
begin

	pImm<=sImm;
	pRT<=pInstruction(20 downto 16);
	pRD<=pInstruction(15 downto 11);

	cControl:eControl port map(pInstruction(31 downto 26),pControl(7),pControl(6),pControl(5),pControl(4),pControl(3),pControl(2),pControl(1),pControl(0),pJump,pReset,pClock);
	cShiftAdder:eShiftAdder port map(pIncpc_in,sImm,pIncpc_out);
	cRegFile:eRegFile port map(pInstruction(25 downto 21),pInstruction(20 downto 16),pWriteReg,pWriteData,pData1,pData2,pRegWE,pReset,not pClock);
	cSignExtend:eSignExtend port map(pInstruction(25 downto 0),sImm);
end behavior;