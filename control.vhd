library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration (component interface)
entity control is
Port (
	clk : in std_logic;											-- Clock signal
	rst : in std_logic;											-- Asynchronous reset
	code_ok : in std_logic;
	exec : in std_logic;										-- Execution control signal
	oper : in std_logic_vector(2 downto 0);	-- Operation code
	arith : out std_logic;									-- Select for arithmetic operation
	clear_c : out std_logic;								-- Clear register s_C
	load_c : out std_logic;									-- Load into register s_C
	copy_c : out std_logic;									-- Copy C value to register copy_of_C
	sel_copy_of_C : out std_logic;					-- Select value from copy_of_C
	rst_counter : out std_logic;						-- Reset counter
	inc_counter : out std_logic;						-- Increment counter
	equal : in std_logic;										-- Counter equal flag
	ready : out std_logic										-- Ready flag
);
end control;

architecture Behavioral of control is

-- Possible states of the state machine
type state_type is (IDLE1, IDLE2, START, LOAD, MUL1, MUL2, MUL3, MUL4, DONE);
-- Signals for current and next state
signal state, next_state : state_type;
	 
begin

-- Update current state
process(clk, rst)
begin
	if rst = '1' then
		state <= IDLE1;
	elsif clk'event and clk = '1' then
		state <= next_state;
	end if;
end process;

-- Process next state and outputs
process(state, code_ok, exec, oper, equal)
begin
	-- Default outputs
	arith <= '0';
	clear_c <= '0';
	load_c <= '0';
	copy_c <= '0';
	sel_copy_of_C <= '0';
	rst_counter <= '0';
	inc_counter <= '0';
	-- ...
	ready <= '0';
	next_state <= state;
		  
	case state is
		-- State IDLE1: system waiting for code_ok signal
		when IDLE1 =>
			if code_ok = '1' then
				next_state <= IDLE2;											-- Next state is IDLE2
			end if;
		-- State IDLE2: system ready, waiting for exec signal
		when IDLE2 =>
			ready <= '1';
			if exec = '1' then
				next_state <= START;											-- Next state is START
			end if;
		-- State START: select operation based on OPER
		when START =>
			if oper = "000" then next_state <= LOAD; 		-- Select load operation (Next state is LOAD)
			elsif oper = "011" then next_state <= MUL1;	-- Select multiplication (Next state is MUL1)
			else next_state <= DONE;										-- Undefined operations go to DONE
			end if;
		-- State LOAD: do C = A
		when LOAD =>
			load_c <= '1';															-- Load into register s_C
			next_state <= DONE;													-- Next state is DONE
		-- State MUL1: initialize multiplication
		when MUL1 =>
			rst_counter <= '1'; 												-- Reset counter
			clear_c <= '1';															-- Clear register s_C
			copy_c <= '1';			 												-- Copy C to copy_of_C
			next_state <= MUL2;													-- Next state is MUL2
		-- State MUL2: check if multiplication is finished (case A = 0)
		when MUL2 =>
			if equal = '1' then													-- Multiplication done?
				next_state <= DONE;												-- Next state is DONE
			else
				next_state <= MUL3;												-- Continue multiplication
			end if;
		-- State MUL3: Increment counter (first addition of C)
		when MUL3 =>
			inc_counter <= '1';
			next_state <= MUL4;													-- Continue
		-- State MUL4: perform addition and update C
		when MUL4 =>
			if equal = '1' then 												-- Multiplication done?
				next_state <= DONE;												-- Next state is DONE
			end if;
			inc_counter <= '1';													-- Increment counter
			sel_copy_of_C <= '1'; 											-- Select (original) C
			arith <= '1'; 															-- Select adder result
			load_c <= '1';  														-- Load intermediate result
		-- State DONE: final state, wait for exec = '0'
		when DONE =>
			if exec = '0' then 
				next_state <= IDLE2;												-- Return to IDLE (ready for new operation)
			end if;
		when others =>
			next_state <= DONE; 												-- Next state is DONE
	end case;
end process;

end Behavioral;

