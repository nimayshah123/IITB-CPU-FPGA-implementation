library ieee;
use ieee.std_logic_1164.all;

entity FSM is
	port(Clk, reset: in std_logic;
			opcode: in std_logic_vector(3 downto 0);
			state: out integer);
end entity;


			
architecture struct of FSM is
	type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s21,s22,s23,s25,s26);
	signal curr_state, next_state: state_type:=s0;
	begin
	
	clock_proc:process(clk,reset, curr_state, opcode)
		begin
		if(clk='1' and clk' event) then
			if(reset='1') then
				curr_state <= s0; 
			else
				curr_state <= next_state;
			end if;
		else
		end if;
	end process;
	
	
	fsm_process: process(clk, curr_state, opcode)
		begin
		case curr_state is
		
			when s0=>
				if (opcode(3 downto 2) = "00" or opcode(3 downto 2) = "01" or opcode(3 downto 2) = "10") then
					next_state <= s1;
				elsif (opcode = "1100") then
					next_state <= s3;
				elsif (opcode="1111") then
					next_state <= s19;
				elsif (opcode="1101") then
					next_state <= s21;
				else
					next_state <= s25;
				end if;
				
				
			when s1=>
				if (opcode(3) ='0') then
					next_state <= s3;
				elsif (opcode(3 downto 2)="10") then
					next_state <= s2;
				else
					next_state <= s25;
				end if;
			
			when s2=>
				if (opcode="0000") then
					next_state <= s4;
				elsif (opcode="0010") then
					next_state <= s6;
				elsif (opcode="0011") then
					next_state <= s7;
				elsif (opcode="0001") then
					next_state <= s8;
				elsif (opcode="0100") then
					next_state <= s10;
				elsif (opcode="0101") then
					next_state <= s11;
				elsif (opcode="0110") then
					next_state <= s12;
				elsif (opcode="1000") then
					next_state <= s13;
				elsif (opcode="1001") then
					next_state <= s14;
				elsif (opcode="1010" or opcode="1011") then
					next_state <= s3;
				else
					next_state <= s25;
				end if;
				
			when s3=>
				if (opcode(3)='0') then
					next_state <= s2;
				elsif (opcode="1010" or opcode="1011") then
					next_state <= s15;
				elsif (opcode="1100") then
					next_state <= s6;
				else
					next_state <= s25;
				end if;

			when s4=>
				next_state <= s5;
			when s5=>
				next_state <= s25;
				
			when s6=>
				if (opcode="0010") then
					next_state <= s5;
				elsif (opcode="1100") then
					next_state <= s18;
				else
					next_state <= s25;
				end if;

			when s7=>
				next_state <= s5;
			when s8=>
				next_state <= s9;
			when s9=>
				next_state <= s25;
			when s10=>
				next_state <= s5;
			when s11=>
				next_state <= s5;
			when s12=>
				next_state <= s5;
			when s13=>
				next_state <= s25;
			when s14=>
				next_state <= s25;
			
			when s15=>
				if (opcode="1010") then
					next_state <= s16;
				elsif (opcode="1011") then
					next_state <= s17;
				else
					next_state <= s25;
				end if;
				
			when s16=>
				next_state <= s25;
			when s17=>
				next_state <= s25;
			when s18=>
				next_state <= s2;
				
			when s19=>
				if (opcode="1111") then
					next_state <= s23;
				else
					next_state <= s25;
				end if;
			
			when s21=>
				next_state <= s26;
			when s22=>
				next_state <= s2;
			
			when s23=>
				if (opcode ="1111") then
					next_state <= s22;
				else
					next_state <= s25;
				end if;
					
				
			when s25=>
				next_state <= s0;
				
			when s26=>
				next_state <= s2;
			
			when others=>
				
		end case;
	end process;
	
	
	out_proc: process(clk, curr_state)
		begin
		case curr_state is
			when s0=>
				state<=0;
			when s1=>
				state<=1;
			when s2=>
				state<=2;
			when s3=>
				state<=3;
			when s4=>
				state<=4;
			when s5=>
				state<=5;
			when s6=>
				state<=6;
			when s7=>
				state<=7;
			when s8=>
				state<=8;
			when s9=>
				state<=9;
			when s10=>
				state<=10;
			when s11=>
				state<=11;
			when s12=>
				state<=12;
			when s13=>
				state<=13;
			when s14=>
				state<=14;
			when s15=>
				state<=15;
			when s16=>
				state<=16;
			when s17=>
				state<=17;
			when s18=>
				state<=18;
			when s19=>
				state<=19;
			when s21=>
				state<=21;
			when s22=>
				state<=22;
			when s23=>
				state<=23;
			when s25=>
				state<=25;
			when s26=>
				state<=26;
			when others=>
		end case;
	end process;				
		
end struct;