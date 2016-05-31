library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4 is
  port (
    -- les 2 switchs
    swt : in std_logic_vector (1 downto 0);
    -- les anodes pour sélectionner l'afficheur 7 segments
    an : out std_logic_vector (7 downto 0);
    -- afficheur 7 segments (point décimal compris, segment 7)
    ssg : out std_logic_vector (7 downto 0);
    -- horloge
    mclk : in std_logic;
    -- les 5 leds
    led : out std_logic_vector (4 downto 0)
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

  component 2_10to2_4d port (
	   X : out std_logic_vector (9 downto 0);
	   Y: out std_logic_vector (9 downto 0);
           e0 : in std_logic_vector (3 downto 0);
           e1 : in std_logic_vector (3 downto 0);
           e2 : in std_logic_vector (3 downto 0);
           e3 : in std_logic_vector (3 downto 0);
           e4 : in std_logic_vector (3 downto 0);
           e5 : in std_logic_vector (3 downto 0);
           e6 : in std_logic_vector (3 downto 0);
           e7 : in std_logic_vector (3 downto 0););
  end component;

begin


    
end synthesis;
