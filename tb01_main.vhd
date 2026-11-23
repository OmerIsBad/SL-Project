LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb01_main IS
END tb01_main;
 
ARCHITECTURE behavior OF tb01_main IS 
 
    COMPONENT main
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         code_in : IN  std_logic;
         bit_ready : IN  std_logic;
         exec : IN  std_logic;
         oper : IN  std_logic_vector(2 downto 0);
         A : IN  std_logic_vector(3 downto 0);
         C : OUT  std_logic_vector(7 downto 0);
         ca : OUT  std_logic;
         cb : OUT  std_logic;
         cc : OUT  std_logic;
         cd : OUT  std_logic;
         ce : OUT  std_logic;
         cf : OUT  std_logic;
         cg : OUT  std_logic;
         cp : OUT  std_logic;
         an3 : OUT  std_logic;
         an2 : OUT  std_logic;
         an1 : OUT  std_logic;
         an0 : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal code_in : std_logic := '0';
   signal bit_ready : std_logic := '0';
   signal exec : std_logic := '0';
   signal oper : std_logic_vector(2 downto 0) := (others => '0');
   signal A : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal C : std_logic_vector(7 downto 0);
   signal ca : std_logic;
   signal cb : std_logic;
   signal cc : std_logic;
   signal cd : std_logic;
   signal ce : std_logic;
   signal cf : std_logic;
   signal cg : std_logic;
   signal cp : std_logic;
   signal an3 : std_logic;
   signal an2 : std_logic;
   signal an1 : std_logic;
   signal an0 : std_logic;

   constant clk_period : time := 10 ns;
 
BEGIN
 
   uut: main PORT MAP (
          clk => clk,
          rst => rst,
          code_in => code_in,
          bit_ready => bit_ready,
          exec => exec,
          oper => oper,
          A => A,
          C => C,
          ca => ca,
          cb => cb,
          cc => cc,
          cd => cd,
          ce => ce,
          cf => cf,
          cg => cg,
          cp => cp,
          an3 => an3,
          an2 => an2,
          an1 => an1,
          an0 => an0
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
		-- Apply reset
		rst <= '1';
		wait for clk_period;
		rst <= '0';
		code_in <= '0';
		bit_ready <= '0';
		wait for clk_period;
		-- Insert code
		code_in <= '1';
      wait for clk_period/2; bit_ready <= '1'; wait for clk_period/2; bit_ready <= '0'; wait for clk_period/2;
		code_in <= '0';
      wait for clk_period/2; bit_ready <= '1'; wait for clk_period/2; bit_ready <= '0'; wait for clk_period/2;
		code_in <= '1';
      wait for clk_period/2; bit_ready <= '1'; wait for clk_period/2; bit_ready <= '0'; wait for clk_period/2;
		code_in <= '0';
      wait for clk_period/2; bit_ready <= '1'; wait for clk_period/2; bit_ready <= '0'; wait for clk_period/2;
		code_in <= '1';
      wait for clk_period/2; bit_ready <= '1'; wait for clk_period/2; bit_ready <= '0'; wait for clk_period/2;
		code_in <= '0';
      wait for clk_period/2; bit_ready <= '1'; wait for clk_period/2; bit_ready <= '0'; wait for clk_period/2;
		code_in <= '1';
      wait for clk_period/2; bit_ready <= '1'; wait for clk_period/2; bit_ready <= '0'; wait for clk_period/2;
		code_in <= '0';
      wait for clk_period/2; bit_ready <= '1'; wait for clk_period/2; bit_ready <= '0'; wait for clk_period/2;
		-- First test case: Load operation (C = A)
		A <= "0010";							-- Set operand A = 2
		oper <= "000";							-- Load operation
		exec <= '1';							-- Start execution
      wait for clk_period*5;				-- Wait for 5 clock cycles
		exec <= '0';							-- Finish execution
      wait for clk_period*2;
		-- Second test case: Multiplication operation
		A <= "0011";							-- Set operand A = 3
		oper <= "011";							-- Multiplication operation
		exec <= '1';							-- Start execution
      wait for clk_period*10;				-- Wait for 10 clock cycles
		exec <= '0';							-- Finish execution
      wait for clk_period*2;
      wait;
   end process;

END;
