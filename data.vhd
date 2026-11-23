library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity declaration (data part component interface)
entity data is
Port (
	clk : in  std_logic;										-- Clock signal
	arith : in  std_logic;									-- Select for arithmetic operation
	clear_c : in  std_logic;								-- Clear register s_C
	load_c : in  std_logic;									-- Load into register s_C
	copy_c : in  std_logic;									-- Copy C value to register copy_of_C
	sel_copy_of_C : in  std_logic;					-- Select value from copy_of_C
	rst_counter : in  std_logic;						-- Reset counter
	inc_counter : in  std_logic;						-- Increment counter
	equal : out std_logic;									-- Counter equal flag
	A : in  std_logic_vector(3 downto 0);		-- Value of A
	C : out std_logic_vector(7 downto 0)		-- Value of C
 );
end data;

architecture Behavioral of data is

-- Auxiliary signal that carries the selected operand
signal s_data : unsigned(7 downto 0);
signal s_C : unsigned(7 downto 0) := "00000000";	-- Register s_C signal
signal copy_of_C : unsigned(7 downto 0); 					-- Register copy_of_C signal
signal s_counter : unsigned(7 downto 0); 					-- Register s_counter signal

begin

-- Multiplexer: selects between A or copy_of_C depending on sel_copy_of_C
s_data <= copy_of_C when sel_copy_of_C = '1' else unsigned("0000" & A);

-- Update flag 'equal': high when s_counter equals A
equal <= '1' when s_counter = unsigned("0000" & A) else '0';

-- Update output C with the value stored in s_C
C <= std_logic_vector(s_C);

-- Register s_counter
process(clk)
begin
	if clk'event and clk = '1' then									-- Update counter
		if rst_counter = '1' then
				s_counter <= "00000000";									-- Clear register s_counter
		elsif inc_counter = '1' then
				s_counter <= s_counter + "00000001";			-- Increment s_counter by 1
		end if;
	end if;
end process;

-- Register copy_of_C
process(clk)
begin
	if clk'event and clk = '1' then									-- Update register
		if copy_c = '1' then
				copy_of_C <= s_C;													-- Copy value from s_C into copy_of_C
		end if;
	end if;
end process;

-- Adder and Register s_C
process(clk)
begin
	if clk'event and clk = '1' then									-- Update register
		if load_c = '1' then													-- Load value into s_C
			if arith = '1' then														-- of arithmetic operation
				s_C <= s_C + s_data;													-- after perform addition
			else
				s_C <= s_data;															-- Store selected operand
			end if;
		elsif clear_c = '1' then											-- Clear register s_C
			s_C <= "00000000";
		end if;
	end if;
end process;

end Behavioral;

