library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
  port(
    srcA       : in std_logic_vector(31 downto 0);
    srcB       : in std_logic_vector(31 downto 0);
    aluControl : in std_logic_vector(2 downto 0);
    result     : out std_logic_vector(31 downto 0);
    zero       : out std_logic
  );
end alu;

architecture behavior of alu is

  signal a, b : signed(31 downto 0);
  signal res  : signed(31 downto 0);

begin

  -- Conversão para signed para lidar com SLT corretamente
  a <= signed(srcA);
  b <= signed(srcB);

  process(a, b, aluControl)
  begin
    case aluControl is
      when "000" =>  -- Soma
        res <= a + b;
      when "001" =>  -- Subtração
        res <= a - b;
      when "010" =>  -- AND
        res <= a and b;
      when "011" =>  -- OR
        res <= a or b;
      when "100" =>  -- XOR
        res <= a xor b;
      when "101" =>  -- SLT (set if less than)
        if a < b then
          res <= (others => '0');
          res(0) <= '1';
        else
          res <= (others => '0');
        end if;
      when others =>
        res <= (others => '0');  -- Padrão de segurança
    end case;
  end process;

  -- Saída do resultado
  result <= std_logic_vector(res);
  
  -- Sinal zero (para beq/bne)
  zero <= '1' when res = 0 else '0';

end behavior; -- OK (APARENTEMENTE)