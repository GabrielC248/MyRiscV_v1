library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity execute is
    port (
        a          : in std_logic_vector(31 downto 0); -- RD1
        b          : in std_logic_vector(31 downto 0); -- RD2
        c          : in std_logic_vector(31 downto 0); -- ImmExt
        aluSrc     : in std_logic;
        aluControl : in std_logic_vector(2 downto 0);
        aluResult  : out std_logic_vector(31 downto 0);
        zero       : out std_logic
    );
end entity execute;

architecture arch of execute is
    
    signal srcB: std_logic_vector(31 downto 0);

begin
    
    MUX: entity work.mux232
    port map (
        d0 => b,
        d1 => c,
        s => aluSrc,
        y => SrcB
    );
    
    ULA: entity work.alu
    port map (
        srcA => a,
        srcB => srcB,
        aluControl => aluControl,
        result => aluResult,
        zero => zero
    );

end architecture arch; -- OK