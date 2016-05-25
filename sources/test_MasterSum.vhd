LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_MasterSum IS
END test_MasterSum;
 
ARCHITECTURE behavior OF test_MasterSum IS 
  
    COMPONENT sum
    PORT(
         en : IN  std_logic;
         e1 : IN  std_logic_vector(7 downto 0);
         e2 : IN  std_logic_vector(7 downto 0);
         s : OUT  std_logic_vector(7 downto 0);
         carry : OUT  std_logic;
         busy : OUT  std_logic;
         sclk : OUT  std_logic;
         mosi : OUT  std_logic;
         miso : IN  std_logic;
         ss : OUT  std_logic;
         reset : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
	 
	 component slave_sum
	 port ( 
         sclk : in std_logic ;
         mosi : in std_logic ;
         miso : out std_logic ;
         ss   : in  std_logic
       );
	 end component;
    
   --Inputs
   signal en : std_logic := '0';
   signal e1 : std_logic_vector(7 downto 0) := (others => '0');
   signal e2 : std_logic_vector(7 downto 0) := (others => '0');
   signal miso : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal s : std_logic_vector(7 downto 0);
   signal carry : std_logic;
   signal busy : std_logic;
   signal sclk : std_logic;
   signal mosi : std_logic;
   signal ss : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN

   uut: sum PORT MAP (
          en => en,
          e1 => e1,
          e2 => e2,
          s => s,
          carry => carry,
          busy => busy,
          sclk => sclk,
          mosi => mosi,
          miso => miso,
          ss => ss,
          reset => reset,
          clk => clk
        );
		  
	 uut1: slave_sum PORT MAP (
          sclk => sclk,
          mosi => mosi,
          miso => miso,
          ss => ss
        );	  

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   stim_proc: process
   begin		
      wait for 100 ns;	

		reset <= '1';
		en <= '0';
		e1 <= "01010101";
		e2 <= "01010101";
		wait for 10 ns;
		en <= '1';
		wait for 10 ns;
		en <= '0';
      wait until busy = '0';
		
		e1 <= "01010101";
		e2 <= "11010101";
		wait for 10 ns;
		en <= '1';
		wait for 10 ns;
		en <= '0';
      wait until busy = '0';
		
		wait for 10 ns;
		en <= '1';
		wait for 10 ns;
		en <= '0';
      wait until busy = '0';
		
      wait;
   end process;

END;
