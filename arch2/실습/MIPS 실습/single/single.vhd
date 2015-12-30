library ieee; -- includes

use ieee.std_logic_1164.all;

use ieee.std_logic_arith.all;

use ieee.std_logic_signed.all;

use ieee.numeric_std.all;


entity single is -- top entry ports

     port (

          pReset     :     in     std_logic;
          
          pClock     :     in     std_logic;

          pPC     :     out     std_logic_vector(31 downto 0);
          
          // pMR     :     out     std_logic;

        //  pIM     :     out std_logic_vector(31 downto 0);

      //    pBranch     :     out     std_logic

		pSelect			:in std_logic;
		pReset			:in std_logic;
		pClock			:in std_logic
	
	//	pJump			:out std_logic;
		pRegWE			:in std_logic;
	}

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


	signal branchpc1:std_logic_vector(31 downto 0);
	signal branchpc2:std_logic_vector(31 downto 0);
	signal incpc:std_logic_vector(31 downto 0);
	signal nextpc:std_logic_vector(31 downto 0);
	signal instrcution:std_logic_vector(31 downto 0);
	
begin

	pRT<=pInstruction(20 downto 16);
	pRD<=pInstruction(15 downto 11);
    pControl_out<=pControl_in(7 downto 4);
	pWriteData<=pData2;
    pControl_out<=pControl_in(3 downto 2);
	pResult<=pAddress;
	pWriteReg_out<=pWriteReg_in;

	
	process(pReset,sInstruction)
	begin
		if pReset='1' then
			pInstruction<=X"FFFFFFFF";
		else
			pInstruction<=sInstruction;
		end if;
	end process;


cPC:ePC port map(nextpc,branchpc1,not pClock);
	cimem:eImem port map(branchpc1,instruction,pClock);
	cadd4:eAdd4 port map(branchpc1,incpc);
	cmux:eMux32 port map(sJpc,pNextpc,//pSelect,jumppc);


	cDmem:eDmem port map(pAddress(9 downto 2),pWriteData,pControl_in(0),pControl_in(1),pReadData,pClock);
	cMUX5:eMUX5 port map(pRT,pRD,pControl_in(0),pWriteReg);
	cMUX32:eMUX32 port map(pData2,pImm,pControl_in(2),sALUin2);
	cALU:eALU port map(pImm(5 downto 0),pControl_in(1),pControl_in(3),pData1,sALUin2,pBranch,pResult);
	cControl:eControl port map(pInstruction(31 downto 26),pControl(7),pControl(6),pControl(5),pControl(4),pControl(3),pControl(2),pControl(1),pControl(0),pJump,pReset,pClock);
	cShiftAdder:eShiftAdder port map(pIncpc_in,sImm,pIncpc_out);
	cRegFile:eRegFile port map(pInstruction(25 downto 21),pInstruction(20 downto 16),pWriteReg,pWriteData,pData1,pData2,pRegWE,pReset,not pClock);
	cSignExtend:eSignExtend port map(pInstruction(25 downto 0),sImm);
	end behavior;