library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MasterJoystick is port ( 
       en : in std_logic;	-- activation
  		 busy : out std_logic;	-- indicateur d'activité de la communication
	    led1 : in std_logic; -- activation led 1 joystick
		 led2 : in std_logic; -- activation led 2 joystick
	  	 btn1 : out std_logic; -- etat bouton 1 du joystick
		 btn2 : out std_logic; -- etat bouton 2 du joystick
		 btnJ : out std_logic; -- etat bouton du joystick
		 X : out std_logic_vector (9 downto 0); -- position x du joystick
		 Y: out std_logic_vector (9 downto 0); -- position y du joystick
		 sclk : out std_logic;
       miso : in std_logic;
       mosi : out std_logic;
		 ss : out std_logic;
  		 clk : in std_logic;
       reset : in std_logic);
end MasterJoystick;

architecture arch of MasterJoystick is

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
	  type t_etat is (passif, at1, at2, at3, at4, at5, em1, em2, em3, em4, em5);
	  variable etat : t_etat;
	  
	begin
	
	  if (reset = '0') then
	  
		etat := passif;
		cpt := 15;
		busy <= '0';
		ss <= '1';
		
	  elsif (rising_edge(clk)) then
	  	-- automate à état (en attente de communication, attente avant première émission, échange premier octet, attente entre deux échanges, échange second octet, ...)
		case etat is 
		
		  when passif =>
			if (en = '1') then
				cpt := 15;
				busy <= '1';
				ss <= '0';
				etat := at1;
			end if;
			
		  when at1 =>
			if (cpt = 0) then 
			  e_en <= '1';
			  din <= ( 7 => '1', 1 => led2, 0 => led1, others => '0');
			  etat := em1;
			else
			  cpt := cpt - 1;
			end if;
			
		  when em1 =>
			if (e_busy = '0' and e_en = '0') then
			  X(7 downto 0) <= dout;
			  cpt := 10;
			  etat := at2;
			else
			  e_en <= '0';
			end if;
			
		  when at2 =>
			if (cpt = 0) then
			  e_en <= '1';
			  din <= (others => '0');
			  etat := em2;
			else
			  cpt := cpt - 1;
			end if;
			
		  when em2 =>
			if (e_busy = '0' and e_en = '0') then
			  X(9 downto 8) <= dout(1 downto 0);
			  cpt := 10;
			  etat := at3;
			else
			  e_en <= '0';
			end if;	
			
		  when at3 =>
			if (cpt = 0) then
			  e_en <= '1';
			  etat := em3;
			else
			  cpt := cpt - 1;
			end if;
			
		  when em3 =>
			if (e_busy = '0' and e_en = '0') then
			  Y(7 downto 0) <= dout;
			  cpt := 10;
			  etat := at4;
			else
			  e_en <= '0';
			end if;
			
		  when at4 =>
			if (cpt = 0) then
			  e_en <= '1';
			  etat := em4;
			else
			  cpt := cpt - 1;
			end if;
			
		  when em4 =>
			if (e_busy = '0' and e_en = '0') then
			  Y(9 downto 8) <= dout(1 downto 0);
			  cpt := 10;
			  etat := at5;
			else
			  e_en <= '0';
			end if;
			
		  when at5 =>
			if (cpt = 0) then
			  e_en <= '1';
			  etat := em5;
			else
			  cpt := cpt - 1;
			end if;
			
		  when em5 =>
			if (e_busy = '0' and e_en = '0') then
			  busy <= '0';
			  ss <= '1';
			  btn2 <= dout(2);
			  btn1 <= dout(1);
			  btnJ <= dout(0);
			  etat := passif;
			else
			  e_en <= '0';
			end if;
			
		end case;
		
	  end if;
	  
	end process;

end arch;
