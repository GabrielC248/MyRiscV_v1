library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity design is
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity design;

architecture rtl of design is

    -- ifetch
    signal PCSrc      : std_logic;
    signal imm        : std_logic_vector(31 downto 0);
    signal PCCurt     : std_logic_vector(31 downto 0);
    signal PCPlus4    : std_logic_vector(31 downto 0);

    -- controller
    signal op         : std_logic_vector(6 downto 0);
    signal funct3     : std_logic_vector(2 downto 0);
    signal funct7     : std_logic_vector(6 downto 0);
    signal zero       : std_logic;
    signal resultSrc  : std_logic_vector(1 downto 0);
    signal memWrite   : std_logic;
    signal aluSrc     : std_logic;
    signal regWrite   : std_logic;
    signal immSrc     : std_logic_vector(1 downto 0);
    signal aluControl : std_logic_vector(2 downto 0);

    -- decoder
    signal instr      : std_logic_vector(31 downto 0);
    signal wd         : std_logic_vector(31 downto 0);
    signal rd1        : std_logic_vector(31 downto 0);
    signal rd2        : std_logic_vector(31 downto 0);
    signal immExt     : std_logic_vector(31 downto 0);

    -- execute
    signal aluResult  : std_logic_vector(31 downto 0);

    -- ram
    signal ramOut     : std_logic_vector(31 downto 0);

begin
    
    instruction_fetch : entity work.ifetch
    port map (
        clk => clk,
        rst => rst,
        PCSrc => PCSrc,
        imm => imm,
        PCCurt => PCCurt,
        PC4Out => PCPlus4
    );

    ctrl : entity work.controller
    port map (
    op         => op,
    funct3     => funct3,
    funct7     => funct7,
    zero       => zero,
    resultSrc  => resultSrc,
    memWrite   => memWrite,
    PCSrc      => PCSrc,
    aluSrc     => aluSrc,
    regWrite   => regWrite,
    immSrc     => immSrc,
    aluControl => aluControl
    );

    instruction_decoder : entity work.idecoder
    port map (
        clk    => clk,
        rst    => rst,
        instr  => instr,
        we     => regWrite,
        immSrc => immSrc,
        wd     => wd,
        op     => op,
        funct3 => funct3,
        funct7 => funct7,
        rd1    => rd1,
        rd2    => rd2,
        immExt => immExt
    );

    exe : entity work.execute
    port map (
        a          => rd1,
        b          => rd2,
        c          => immExt,
        aluSrc     => aluSrc,
        aluControl => aluControl,
        aluResult  => aluResult,
        zero       => zero
    );

    ROM_M: entity work.rom
    generic map (
        DATA_WIDTH    => 8,
        ADDRESS_WIDTH => 16,
        DEPTH         => 65535
        )
    port map (
        a  => PCCurt,
        rd => instr
    );

    RAM_M: entity work.ram
    generic map (
        DATA_WIDTH    => 8,
        ADDRESS_WIDTH => 16,
        DEPTH         => 65535
        )
    port map (
        clk => clk,
        a   => aluResult,
        wd  => rd2,
        we  => memWrite,
        rd  => ramOut
    );

    MUX3: entity work.mux332
    port map (
        d0 => aluResult,
        d1 => ramOut,
        d2 => PCPlus4,
        s => resultSrc,
        y => wd
    );

end architecture rtl;