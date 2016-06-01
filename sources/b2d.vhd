library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_std.all;

entity b2d is
  port (
	   X : in std_logic_vector (9 downto 0);
	   Y: in std_logic_vector (9 downto 0);
           e0 : out std_logic_vector (3 downto 0);
           e1 : out std_logic_vector (3 downto 0);
           e2 : out std_logic_vector (3 downto 0);
           e3 : out std_logic_vector (3 downto 0);
           e4 : out std_logic_vector (3 downto 0);
           e5 : out std_logic_vector (3 downto 0);
           e6 : out std_logic_vector (3 downto 0);
           e7 : out std_logic_vector (3 downto 0));
end b2d;

architecture synthesis of b2d is
	
	signal x_tmp : Integer;
	signal y_tmp : Integer;

begin

  x_tmp <= to_integer(unsigned(X));


  e4 <= x_tmp mod 10;
  e5 <= (x_tmp / 10) mod 10;
  e6 <= (x_tmp / 100) mod 10;
  e7 <= (x_tmp / 1000) mod 10;
  
  e0 <= y_tmp mod 10;
  e1 <= (y_tmp / 10) mod 10;
  e2 <= (y_tmp / 100) mod 10;
  e3 <= (y_tmp / 1000) mod 10;


end synthesis;
