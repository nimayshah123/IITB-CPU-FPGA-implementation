library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;


entity ALU is
	port (A: in std_logic_vector(15 downto 0);
			B: in std_logic_vector(15 downto 0);
			state: in std_logic_vector(4 downto 0);
			C: out std_logic_vector(15 downto 0);
			Z: out std_logic);
end ALU;


architecture struct of ALU is


	function add(A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable sum: std_logic_vector(15 downto 0):=(others=>'0');
		begin
			sum:= std_logic_vector(to_signed((to_integer(signed(A)) + to_integer(signed(B))),16));
		return sum;
	end add;
	
	function subtract(A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable diff: std_logic_vector(15 downto 0):=(others=>'0');
		begin
			diff:= std_logic_vector(to_signed((to_integer(signed(A)) - to_integer(signed(B))),16));
		return diff;
	end subtract;
	
	function multiply(A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable ans: std_logic_vector(15 downto 0):=(others=>'0');
		begin
			ans:= std_logic_vector(to_signed((to_integer(signed(A(3 downto 0))) * to_integer(signed(B(3 downto 0)))),16));
		return ans;
	end multiply;
	
	function and_ab(A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable ans: std_logic_vector(15 downto 0):=(others=>'0');
		begin
			for_loop: for i in 15 downto 0 loop
				ans(i) := A(i) and B(i);
			end loop;
			return ans;			
	end and_ab;
	
	function or_ab(A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable ans: std_logic_vector(15 downto 0):=(others=>'0');
		begin
			for_loop: for i in 15 downto 0 loop
				ans(i) := A(i) or B(i);
			end loop;
			return ans;			
	end or_ab;
	
	function imp_ab(A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable ans: std_logic_vector(15 downto 0):=(others=>'0');
		begin
			for_loop: for i in 15 downto 0 loop
				ans(i) := (not A(i)) or B(i);
			end loop;
			return ans;			
	end imp_ab;
	
	function shift_add(A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0)) 
		return std_logic_vector is
			variable sum: std_logic_vector(15 downto 0):=(others=>'0');
			variable b_new: std_logic_vector(15 downto 0);
		begin
			for_loop: for i in 15 downto 1 loop
				b_new(i) := B(i-1) ;
			end loop;
			b_new(0):='0';
			sum:= std_logic_vector(to_unsigned((to_integer(unsigned(A)) + to_integer(unsigned(b_new))),16));
		return sum;
	end shift_add;
	
	signal C_var: std_logic_vector(15 downto 0);
	signal Z_var: std_logic;

begin

	alu_proc: process(A,B,state)
		begin
		if (state="00001" or state="00100" or state="01000" or state="01111" or state="10100" or state="10101" or state="10010") then
			C_var<= add(A,B);
			Z_var<= '0';
	
		elsif (state="00110") then
			C_var<= subtract(A,B);
			if (subtract(A,B) = "0000000000000000") then
				Z_var<= '1';
			else
				Z_var<= '0';
			end if;
		elsif (state="00111") then
			C_var<= multiply(A,B);
			Z_var<='0';
		elsif (state="01010") then
			C_var<= and_ab(A,B);
			Z_var<='0';
		elsif (state="01011") then
			C_var<= or_ab(A,B);
			Z_var<='0';
		elsif (state="01100") then
			C_var<= imp_ab(A,B);
			Z_var<='0';
		else
		end if;
	end process;
	
	C<=C_var;
	Z<=Z_var;

end struct;