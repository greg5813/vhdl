library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sum is port ( 
  		 en : in std_logic;
  		 e1 : in std_logic_vector (7 downto 0);
  		 e2 : in std_logic_vector (7 downto 0);
  		 s : out std_logic_vector (7 downto 0);
  		 carry : out std_logic;
  		 busy : out std_logic;
         sclk : out std_logic ;
         mosi : out std_logic ;
         miso : in std_logic ;
         ss   : out  std_logic;
		 reset : in std_logic;
		 clk : in std_logic );
end sum;

architecture arch of sum is

end arch;
