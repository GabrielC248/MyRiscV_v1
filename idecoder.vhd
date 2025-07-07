library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity idecoder is
    port (
        clk    : in std_logic;
        rst    : in std_logic;
        instr  : in std_logic_vector(31 downto 0);
        we     : in std_logic;
        immSrc : in std_logic_vector(1 downto 0);
        wd     : in std_logic_vector(31 downto 0);
        op     : out std_logic_vector(6 downto 0);
        funct3 : out std_logic_vector(2 downto 0);
        funct7 : out std_logic_vector(6 downto 0);
        rd1    : out std_logic_vector(31 downto 0);
        rd2    : out std_logic_vector(31 downto 0);
        immExt : out std_logic_vector(31 downto 0)
    );
end entity idecoder;

architecture arch of idecoder is

    signal rs1 : std_logic_vector(4 downto 0);
    signal rs2 : std_logic_vector(4 downto 0);
    signal rd  : std_logic_vector(4 downto 0);
    signal imm : std_logic_vector(24 downto 0);

begin
    
    op <= instr(6 downto 0);
    funct3 <= instr(14 downto 12);
    funct7 <= instr(31 downto 25);
    rs1 <= instr(19 downto 15);
    rs2 <= instr(24 downto 20);
    rd <= instr(11 downto 7);
    imm <= instr(31 downto 7);
    
    regs : entity work.registers
    port map (
        clk => clk,
        rst => rst,
        a1 => rs1,
        a2 => rs2,
        we => we,
        a3 => rd,
        wd => wd,
        rd1 => rd1,
        rd2 => rd2
    );

    immExtend : entity work.extend
    port map (
        imm => imm,
        immSrc => immSrc,
        immExt => immExt
    );

end architecture arch; -- OK