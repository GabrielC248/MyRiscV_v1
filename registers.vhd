library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity registers is
    port (
        clk : in std_logic;
        rst : in std_logic;
        a1  : in std_logic_vector(4 downto 0);   -- RS1
        a2  : in std_logic_vector(4 downto 0);   -- RS2
        we  : in std_logic;                      -- when 1, write wd in RD
        a3  : in std_logic_vector(4 downto 0);   -- RD
        wd  : in std_logic_vector(31 downto 0);  -- Write Data
        rd1 : out std_logic_vector(31 downto 0); -- Read data 1
        rd2 : out std_logic_vector(31 downto 0)  -- Read data 2
    );
end entity registers;

architecture arch of registers is

    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal regs : reg_array := (others => (others => '0'));

begin

    process(clk)
    begin
        if falling_edge(clk) then
            if we = '1' and a3 /= "00000" then
                regs(to_integer(unsigned(a3))) <= wd;
            end if;
        end if;
    end process;

    rd1 <= regs(to_integer(unsigned(a1)));
    rd2 <= regs(to_integer(unsigned(a2)));

end architecture arch; -- OK