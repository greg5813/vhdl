library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity er_1octet is port ( 
       en : in std_logic;
  		 din : in std_logic_vector (7 downto 0);
  		 dout : out std_logic_vector (7 downto 0);
  		 busy : out std_logic;
  		 sclk : out std_logic;
       miso : in std_logic;
       mosi : out std_logic;
  		 clk : in std_logic;
       reset : in std_logic);
end er_1octet;

architecture arch of er_1octet is
begin
  	process (clk,reset)
	  variable cpt : natural;
	  variable registre : std_logic_vector (7 downto 0);
	  type t_etat is (passif, un, deux);
	  variable etat : t_etat;
	begin
	  if (reset = '0') then
		etat := passif;
		cpt := 7;
		registre := (others => '0');
		dout <= (others => '0');
		sclk <= '0';
		busy <= '0';
		mosi <= '0';
	  elsif (rising_edge(clk)) then
		case etat is
		  when passif => 
			if (en = '1') then
			  registre := din;
			  cpt := 7;
			  busy <= '1';
			  mosi <= registre(cpt);
			  etat := un;
		    end if;
		  when un => 
			sclk <= '1';
			registre(cpt) := miso;
			etat := deux;
		  when deux =>
			sclk <= '0';
			if (cpt = 0) then
			  busy <= '0';
			  dout <= registre;
			  etat := passif;
			else
			  cpt := cpt - 1;
			  mosi <= registre(cpt);
			  etat := un;
			end if;
		end case;
	  end if;
	end process;
end arch;
