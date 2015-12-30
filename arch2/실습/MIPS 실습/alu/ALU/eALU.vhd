library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity eALU is
	port(
		pOperator		:in std_logic_vector(5 downto 0);
		pOperation		:in std_logic;
		pBranch			:in std_logic;
		pIn1			:in std_logic_vector(31 downto 0);
		pIn2			:in std_logic_vector(31 downto 0);
		pBranch_out		:out std_logic;
		pOut			:out std_logic_vector(31 downto 0)
	);
end eALU;

architecture behavior of eALU is
	signal sO : std_logic_vector(31 downto 0);
	signal sBranch:std_logic;
begin
	process(sO,pOperator)
	begin
		if pOperator="101010" then
			pOut(0)<=sO(31);
			for N in 1 to 31 loop
				pOut(N)<='0';
			end loop;
		else
			pOut<=sO;
		end if;
	end process;

	process(pOperation,pOperator,pBranch,pIn1,pIn2,sO,sBranch)
	begin
		pBranch_out<=pBranch;

		if sO=X"00000000" then
			sBranch<='1';
		else
			sBranch<='0';
		end if;

		if pOperation='1' then
			case pOperator is
				--add
				when "100000" =>	sO <= pIn1 + pIn2;
				--sub
				when "100010" =>	sO <= pIn1 - pIn2;
				--and
				when "100100" =>	sO <= pIn1 and pIn2;
				--or
				when "100101" =>	sO <= pIn1 or pIn2;
				--slt
				when "101010" =>	sO <= pIn1 - pIn2;
				--lw,sw
				when others =>	sO <= pIn1 + pIn2;
			end case;

			if pBranch='1' then
				--bne
				sO<=pIn1-pIn2;
				pBranch_out<=not sBranch;
			end if;
		else
			if pBranch='1' then
				--beq
				sO<=pIn1-pIn2;
				pBranch_out<=sBranch;
			else
				--lw,sw
				sO<=pIn1+pIn2;
			end if;				
		end if;
	end process;
end behavior;
