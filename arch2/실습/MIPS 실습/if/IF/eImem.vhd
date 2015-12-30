library ieee;
use ieee.std_logic_1164.all;
library lpm;
use lpm.lpm_components.all;

entity eImem is
	port (
		pReadaddr	: in	std_logic_vector(31 downto 0);
		pDataout	: out	std_logic_vector(31 downto 0);
		pClock		: in	std_logic
	);
end eImem;

architecture behavior of eImem is
begin
	data_memory: lpm_rom
	generic map(
		lpm_widthad			=> 8,
		lpm_outdata			=> "UNREGISTERED",
		lpm_address_control	=> "REGISTERED",
		lpm_file			=> "imem.mif",
		lpm_width			=> 32)
	
	port map (
		address				=> pReadaddr(9 downto 2),
		q					=> pDataout,
		inclock				=> pClock);

end behavior;