library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity disp_basys2SL is
    port( clk:		in STD_LOGIC;
			 dig3:		in STD_LOGIC_VECTOR(3 downto 0);
			 dig2:		in STD_LOGIC_VECTOR(3 downto 0);
			 dig1:		in STD_LOGIC_VECTOR(3 downto 0);
			 dig0:		in STD_LOGIC_VECTOR(3 downto 0);
			 segA: 		out STD_LOGIC;
			 segB: 		out STD_LOGIC;
			 segC: 		out STD_LOGIC;
			 segD: 		out STD_LOGIC;
			 segE: 		out STD_LOGIC;
			 segF: 		out STD_LOGIC;
			 segG: 		out STD_LOGIC;
			 segP: 		out STD_LOGIC;
			 an3: 		out STD_LOGIC;
			 an2: 		out STD_LOGIC;
			 an1: 		out STD_LOGIC;
			 an0: 		out STD_LOGIC
	);
end disp_basys2SL;

architecture Behavioral of disp_basys2SL is

  procedure hexdigit ( val : STD_LOGIC_VECTOR( 3 downto 0 );
							  signal ret : out STD_LOGIC_VECTOR( 7 downto 0 ) ) is 
  begin
    case val is
	     when x"0" =>   ret <= "00000011";
		  when x"1" =>   ret <= "10011111";
		  when x"2" =>   ret <= "00100101";
		  when x"3" =>   ret <= "00001101";
		  when x"4" =>   ret <= "10011001";
		  when x"5" =>   ret <= "01001001";
		  when x"6" =>   ret <= "01000001";
		  when x"7" =>   ret <= "00011111";
		  when x"8" =>   ret <= "00000001";
		  when x"9" =>   ret <= "00001001";
		  when x"A" =>   ret <= "00010001";
		  when x"B" =>   ret <= "11000001";
		  when x"C" =>   ret <= "01100011";
		  when x"D" =>   ret <= "10000101";
		  when x"E" =>   ret <= "01100001";
		  when x"F" =>   ret <= "01110001";
		  when others => ret <= "11111111";
	end case;
  end hexdigit;

  signal nibble: STD_LOGIC_VECTOR( 3 downto 0 );
  signal digit: STD_LOGIC_VECTOR( 1 downto 0 );
  signal counter: STD_LOGIC_VECTOR( 15 downto 0 );
  signal segs: STD_LOGIC_VECTOR( 7 downto 0 );
  signal value: STD_LOGIC_VECTOR( 15 downto 0 );

begin
   -- slowdown digit scanning
   counter <= counter + 1 when rising_edge( clk );
	
	digit <= counter( 15 downto 14 );
	
	value(15) <= dig3(3);
	value(14) <= dig3(2);
	value(13) <= dig3(1);
	value(12) <= dig3(0);
	value(11) <= dig2(3);
	value(10) <= dig2(2);
	value(9) <= dig2(1);
	value(8) <= dig2(0);
	value(7) <= dig1(3);
	value(6) <= dig1(2);
	value(5) <= dig1(1);
	value(4) <= dig1(0);
	value(3) <= dig0(3);
	value(2) <= dig0(2);
	value(1) <= dig0(1);
	value(0) <= dig0(0);
	
   nibble <= value( 3 downto  0) when digit = "00" else
				 value( 7 downto  4) when digit = "01" else
				 value(11 downto  8) when digit = "10" else
				 value(15 downto 12) when digit = "11" else
				 "0000";
				 
	an0 <= '0' when digit = "00" else '1';
	an1 <= '0' when digit = "01" else '1';
	an2 <= '0' when digit = "10" else '1';
	an3 <= '0' when digit = "11" else '1';
	
	hexdigit( nibble, segs );

	segA <= segs (7);
	segB <= segs (6);
	segC <= segs (5);
	segD <= segs (4);
	segE <= segs (3);
	segF <= segs (2);
	segG <= segs (1);
	segP <= segs (0);
	
end Behavioral;