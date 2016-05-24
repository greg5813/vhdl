LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY test_er_1octet IS
END test_er_1octet;
 
ARCHITECTURE behavior OF test_er_1octet IS 
 
    COMPONENT er_1octet
    PORT(
         en : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         dout : OUT  std_logic_vector(7 downto 0);
         busy : OUT  std_logic;
         sclk : OUT  std_logic;
         miso : IN  std_logic;
         mosi : OUT  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal en : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal miso : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(7 downto 0);
   signal busy : std_logic;
   signal sclk : std_logic;
   signal mosi : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: er_1octet PORT MAP (
          en => en,
          din => din,
          dout => dout,
          busy => busy,
          sclk => sclk,
          miso => miso,
          mosi => mosi,
          clk => clk,
          reset => reset
        );
 
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      -- insert stimulus here 
		
		reset <= '1';
		en <= '0';
		din <= "10101010";
		wait for 10 ns;
		en <= '1';
		wait for 10 ns;
		en <= '0';
      wait until busy = '0';
		
		wait for 10 ns;
		
		din <= "01010101";
		wait for 10 ns;
		en <= '1';
		wait for 10 ns;
		en <= '0';
      wait until busy = '0';

		wait for 10 ns;
		
		din <= "10111101";
		wait for 10 ns;
		en <= '1';
		wait for 10 ns;
		en <= '0';
      wait until busy = '0';					
		
		wait;
		
   end process;   
	
	stim_proc2: process
		variable donnee : std_logic_vector (7 downto 0);
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      -- insert stimulus here 
		
		donnee := "11111111";
		wait until busy = '1';
		for I in 0 to 7 loop
			miso <= donnee(7-I);
			wait for 20 ns;
		end loop;
		
		donnee := "00000000";
		wait until busy = '1';
		for I in 0 to 7 loop
			miso <= donnee(7-I);
			wait for 20 ns;
		end loop;
		
		donnee := "10011001";
		wait until busy = '1';
		for I in 0 to 7 loop
			miso <= donnee(7-I);
			wait for 20 ns;
		end loop;
		
		wait;
		
   end process;

END;