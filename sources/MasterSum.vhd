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
begin
  	process (clk,reset)
	  variable cpt : natural;
	  variable r1 : std_logic_vector (7 downto 0);
	  variable r2 : std_logic_vector (7 downto 0);
	  type t_etat is (passif, un, deux);
	  variable etat : t_etat;
	begin
	  if (reset = '0') then
		etat := passif;
		cpt := 7;
		r1 := (others => '0');
		r2 := (others => '0');
		s <= (others => '0');
		carry <= '0';
		busy <= '0';
		sclk <= '0';
		mosi <= '0';
		ss <= '0';
	  elsif (rising_edge(clk)) then

	  end if;
	end process;
end arch;
