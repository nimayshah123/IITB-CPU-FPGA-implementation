library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	 

entity Memory is 
	port (add,data_in: in std_logic_vector(15 downto 0); 
			clk,rw: in std_logic;
			data_out: out std_logic_vector(15 downto 0));
end entity;

architecture struct of Memory is 

	type regarray is array(31 downto 0) of std_logic_vector(15 downto 0);

	signal Memory: regarray:=(
		0 =>  "1010000100000110",--LW --000 has 4
		1 =>  "1010001100000101",--LW --001 has -1
		2 =>  "0101000001000000",--OR ---000 has -1
		3 =>  "1100000001000101",--BEQ -- jump to 0
		5 =>  "1111111111111111",--Data
		6 =>  "0000000000000100",--Datac
		8 =>  "1101000000001000", --JAL and go to 16
		16 => "0001001001000001", --ADI
		17 => "1111000001000000", --JLR 
		others => x"0000");

	begin
	
	data_out <= Memory(to_integer(unsigned(add)));
	
	mem_write: process (rw,data_in,add,clk)
		begin
		if(rw = '1') then
			if(rising_edge(clk)) then
				Memory(to_integer(unsigned(add))) <= data_in;
			else
			end if;
		else	
		end if;
	end process;
	
end struct;
