library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4 is
  port (
    -- les 2 switchs pour activer les leds du joystick
    swt : in std_logic_vector (1 downto 0);
    -- les anodes pour sélectionner l'afficheur 7 segments
    an : out std_logic_vector (7 downto 0);
    -- afficheur 7 segments (point décimal compris, segment 7)
    ssg : out std_logic_vector (7 downto 0);
    -- horloge de la carte
    mclk : in std_logic;
    -- les 4 leds pour afficher l'état de la communication(0) et des boutons du joystick
    led : out std_logic_vector (3 downto 0);
	 -- les pins de com avec le joystick
	 ss : out std_logic;
	 miso : in std_logic;
	 mosi : out std_logic;
	 sclk : out std_logic;
	 -- bouton reset
	 btnC : in std_logic
  );
end Nexys4;

architecture synthesis of Nexys4 is

  component MasterJoystick port ( 
       en : in std_logic;
  		 busy : out std_logic;
	    led1 : in std_logic;
		 led2 : in std_logic;
	  	 btn1 : out std_logic;
		 btn2 : out std_logic;
		 btnJ : out std_logic;
		 X : out std_logic_vector (9 downto 0);
		 Y: out std_logic_vector (9 downto 0);
		 sclk : out std_logic;
       miso : in std_logic;
       mosi : out std_logic;
		 ss : out std_logic;
  		 clk : in std_logic;
       reset : in std_logic);
  end component;

  component All7Segments Port ( 
	    clk : in  std_logic;
       reset : in std_logic;
       e0 : in std_logic_vector (3 downto 0);
       e1 : in std_logic_vector (3 downto 0);
       e2 : in std_logic_vector (3 downto 0);
       e3 : in std_logic_vector (3 downto 0);
       e4 : in std_logic_vector (3 downto 0);
       e5 : in std_logic_vector (3 downto 0);
       e6 : in std_logic_vector (3 downto 0);
       e7 : in std_logic_vector (3 downto 0);
       an : out std_logic_vector (7 downto 0);
       ssg : out std_logic_vector (7 downto 0));
  end component;  
  
  component diviseurClk
       generic(facteur : natural);
       port (
       clk, reset : in  std_logic;
       nclk       : out std_logic);
  end component;
  
  signal e2b, e6b : std_logic_vector(3 downto 0);
  signal clk : std_logic;
  signal X,Y : std_logic_vector(9 downto 0);
  
begin

  MJ :  MasterJoystick 
  port map ( en => '1',
				 busy => led(0),
				 led1 => swt(0),
				 led2 => swt(1),
				 btn1 => led(1),
				 btn2 => led(2),
				 btnJ => led(3), 
				 X => X,
				 Y => Y,
				 sclk => sclk,
				 miso => miso,
				 mosi => mosi,
				 ss => ss,
				 clk => clk,
				 reset => not btnC);
  
  e2b <= ( 0 => Y(8), 1 => Y(9), others => '0');
  e6b <= ( 0 => X(8), 1 => X(9), others => '0');  
  
  A7 : All7Segments 
  Port map( clk => mclk,
				reset =>  not btnC, 
				e0 => Y(3 downto 0),
				e1 => Y(7 downto 4),
				e2 => e2b,
				e3 => "0000",
				e4 => X(3 downto 0),
				e5 => X(7 downto 4),
				e6 => e6b,
				e7 => "0000", 
				an => an,
				ssg => ssg);
   
  DC : diviseurClk
    generic map(100)
    port map(
				clk => mclk,
				reset => not btnC,
				nclk => clk);
	
end synthesis;
