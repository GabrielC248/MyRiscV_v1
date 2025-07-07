library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rreg32 is
  port (
    clk : in std_logic;
    rst : in std_logic;
    d   : in std_logic_vector(31 downto 0);
    q   : out std_logic_vector(31 downto 0)
  );
end rreg32;

architecture behavior of rreg32 is

begin

  async_proc: process(clk, rst)
  begin
    if rst = '0' then
      q <= (q'range => '0');  
    elsif falling_edge(clk) then
      q <= d;
    end if;
  end process async_proc;

end behavior; -- OK