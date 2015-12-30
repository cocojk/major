library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
library lpm;
use lpm.lpm_components.all;

entity eDmem is
	port(
		pAddress		:in		std_logic_vector(31 downto 0);
		pWriteData		:in		std_logic_vector(31 downto 0);
		pOE				:in		std_logic;
		pWE				:in		std_logic;
		pReadData		:out	std_logic_vector(31 downto 0);
		pClock			:in		std_logic
	);
end eDmem;

architecture behavior of eDmem is
	signal sOut:std_logic_vector(31 downto 0);
begin
	data_memory	:	lpm_ram_dq

	generic map (
		lpm_widthad			=>	8,
		lpm_outdata			=>	"UNREGISTERED",
		lpm_indata			=>	"REGISTERED",
		lpm_address_control	=>	"REGISTERED",
		lpm_file			=>	"dmem.mif",
		lpm_width			=>	32 )

	port map (
		data => pWriteData,
		address => pAddress(9 downto 2),
		we => pWE,
		inclock => not pClock,
		q => sOut );
		
	process(pOE,sOut)
	begin
		if pOE='1' then
			pReadData<=sOut;
		else
			pReadData<="ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
		end if;
	end process;
end behavior;