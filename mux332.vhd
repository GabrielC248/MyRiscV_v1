library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux332 is
  port(	
    d0, d1, d2 : in std_logic_vector(31 downto 0);
    s          : in std_logic_vector(1 downto 0);
    y	       : out std_logic_vector(31 downto 0)
  );
end mux332;

architecture behavior of mux332 is
begin
  y <= d0 when s = "00" else 
       d1 when s = "01" else 
       d2 when s = "10";
end behavior;
