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
  
  component er_1octet port (
         en : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         dout : OUT  std_logic_vector(7 downto 0);
         busy : OUT  std_logic;
         sclk : OUT  std_logic;
         miso : IN  std_logic;
         mosi : OUT  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic );
   end component;
    
   signal e_en : std_logic := '0';
   signal e_busy : std_logic;
   signal din : std_logic_vector(7 downto 0);
   signal dout : std_logic_vector(7 downto 0);
	
begin   

	uut: er_1octet PORT MAP (
     en => e_en,
     din => din,
     dout => dout,
     busy => e_busy,
     sclk => sclk,
	  miso => miso,
     mosi => mosi,
     clk => clk,
     reset => reset
    );
	 
   process (clk,reset)
	  variable cpt : natural;
	  type t_etat is (passif, attente1, attente2, emission1, emission2);
	  variable etat : t_etat;
	begin
	  if (reset = '0') then

		etat := passif;
		cpt := 4;
		s <= (others => '0');
		carry <= '0';
		busy <= '0';
		ss <= '1';

	  elsif (rising_edge(clk)) then

		case etat is 

		  when passif =>
			if (en = '1') then
				cpt := 4;
				busy <= '1';
				ss <= '0';
				etat := attente1;
			end if;

		  when attente1 =>
			if (cpt = 0) then 
			  e_en <= '1';
			  din <= e1;
			  etat := emission1;
			else
			  cpt := cpt - 1;
			end if;

		  when emission1 =>
			if (e_busy = '0' and e_en = '0') then
			  s <= dout;
			  cpt := 1;
			  etat := attente2;
			else
			  e_en <= '0';
			end if;

		  when attente2 =>
			if (cpt = 0) then
			  e_en <= '1';
			  din <= e2;
			  etat := emission2;
			else
			  cpt := cpt - 1;
			end if;

		  when emission2 =>
			if (e_busy = '0' and e_en = '0') then
			  busy <= '0';
			  ss <= '1';
			  carry <= dout(0);
			  etat := passif;
			else
			  e_en <= '0';
			end if;

		end case;

	  end if;

	end process;
	
end arch;
