library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity eRegFile is
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
end eRegFile;

architecture behavior of eRegFile is
	type regarray is array(1 to 15) of std_logic_vector(31 downto 0);
	signal saReg		: regarray;
	constant low		: std_logic :='0';
begin
	process(pReadRegister1,pReadRegister2,saReg)
	begin
		if pReadRegister1="00000" then
			pReadData1 <= conv_std_logic_vector(low,32);
		else
			pReadData1 <= saReg( conv_integer(pReadRegister1) );
		end if;
		if pReadRegister2="00000" then
			pReadData2 <= conv_std_logic_vector(low,32);
		else
			pReadData2 <= saReg( conv_integer(pReadRegister2) );
		end if;
	end process;
	
	process
	begin
		wait until pClock'event and pClock='1';
		if pReset='1' then
			for i in 1 to 8 loop
				saReg(i) <= conv_std_logic_vector(i,32);
			end loop;
		elsif pRegWE='1' and pWriteRegister/=0 then
			saReg( conv_integer(pWriteRegister) ) <= pWriteData;
		end if;
	end process;
end behavior;