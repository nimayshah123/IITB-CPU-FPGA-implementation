library ieee;
use ieee.std_logic_1164.all;

entity Reg_file is
	port(RF_A1,RF_A2,RF_A3: in std_logic_vector(2 downto 0);
			RF_D3: in std_logic_vector(15 downto 0);
			rw, Clk, reset: in std_logic;
			RF_D1,RF_D2, RF_D4: out std_logic_vector(15 downto 0);
			RF_OUT0, RF_OUT1, RF_OUT2, RF_OUT3, RF_OUT4, RF_OUT5, RF_OUT6, RF_OUT7: out std_logic_vector(15 downto 0));
end entity;

-- To write: sync write; rw='1' and write data in RF_Din and address input RF_A1
-- To read: async read, doesn't depend on rw or anything else
			
architecture struct of Reg_file is
	signal R2,R3,R4,R5,R6,R7: std_logic_vector(15 downto 0):="0000000000000000";
	signal R0: std_logic_vector(15 downto 0):="0000000000000000";
	signal R1: std_logic_vector(15 downto 0):="0000000000000000";
	
	component mux8_1_16bit is 
		port( A,B,C,D,E,F,G,H: in std_logic_vector(15 downto 0);sel0,sel1,sel2 : in std_logic; Y: out std_logic_vector(15 downto 0));
	end component;

	begin
	
	write_process: process(clk, RF_A1, RF_A2, RF_A3, RF_D3, rw)
	begin
		if (reset ='1') then
			R0<="0000000000000000";
			R1<="0000000000000000";
			R2<="0000000000000000";
			R3<="0000000000000000";
			R4<="0000000000000000";
			R5<="0000000000000000";
			R6<="0000000000000000";
			R7<="0000000000000000";
			
		else
			if (rw='1') then
				if (Clk'event and Clk='1') then
					case RF_A3 is
						when "000" =>
							R0 <= RF_D3;
						when "001" =>
							R1 <= RF_D3;
						when "010" =>
							R2 <= RF_D3;
						when "011" =>
							R3 <= RF_D3;
						when "100" =>
							R4 <= RF_D3;
						when "101" =>
							R5 <= RF_D3;
						when "110" =>
							R6 <= RF_D3;
						when "111" =>
							R7 <= RF_D3;
						when others=>
					end case;
				else
				end if;
			else
			end if;
		end if;
	end process write_process;
	
	Mux1: mux8_1_16bit port map (R0,R1,R2,R3,R4,R5,R6,R7,RF_A1(0),RF_A1(1),RF_A1(2),RF_D1);
	Mux2: mux8_1_16bit port map (R0,R1,R2,R3,R4,R5,R6,R7,RF_A2(0),RF_A2(1),RF_A2(2),RF_D2);
	
	RF_D4 <= R7;
	
	RF_OUT0 <= R0;
	RF_OUT1 <= R1;
	RF_OUT2 <= R2;
	RF_OUT3 <= R3;
	RF_OUT4 <= R4;
	RF_OUT5 <= R5;
	RF_OUT6 <= R6;
	RF_OUT7 <= R7;
	
end struct;