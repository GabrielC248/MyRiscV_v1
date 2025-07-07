library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder32 is
  port(
    a : in std_logic_vector(31 downto 0);
    b : in std_logic_vector(31 downto 0);
    s : out std_logic_vector(31 downto 0)
  );
end adder32;

architecture behavior of adder32 is
begin

  s <= std_logic_vector( unsigned(a) + unsigned(b) );
  
end behavior; -- OK