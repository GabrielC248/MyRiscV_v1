library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ifetch is
	port (
    	clk    : in std_logic;
    	rst    : in std_logic;
    	PCSrc  : in std_logic;
    	imm    : in std_logic_vector(31 downto 0);
    	PCCurt : out std_logic_vector(31 downto 0); -- PC OUT
        PC4Out : out std_logic_vector(31 downto 0) -- PCPlus4 OUT
    );
end entity ifetch;

architecture arch of ifetch is

	signal PCNext   : std_logic_vector(31 downto 0);
	signal PCPlus4  : std_logic_vector(31 downto 0);
	signal PCTarget : std_logic_vector(31 downto 0);
	signal PCNew    : std_logic_vector(31 downto 0);

	begin

		MUX: entity work.mux232
    	port map (
    		d0 => PCPlus4,
        	d1 => PCTarget,
        	s => PCSrc,
        	y => PCNext
		);
  
		PC: entity work.rreg32
    	port map (
    		clk => clk,
        	rst => rst,
        	d => PCNext,
        	q => PCNew
		);

		ADDERPLUS4 : entity work.adder32
    	port map (
    		a => PCNew,
        	b => x"00000004",
        	s => PCPlus4
    	);

		ADDERTARGET: entity work.adder32
    	port map (
    		a => PCNew,
        	b => imm,
        	s => PCTarget
    	);

		PCCurt <= PCNew;
        PC4Out <= PCPlus4;

end architecture arch; -- OK