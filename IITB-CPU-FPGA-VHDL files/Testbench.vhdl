library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Testbench is
end entity;

architecture Struct of Testbench is
   component CPU is
		port(Clk, reset, pb: in std_logic;
		sw: in std_logic_vector(7 downto 0);
		reg_out: out std_logic_vector(7 downto 0));
	end component;


   signal Clk, Reset, pb: std_logic:='0';
	signal sw, reg_out: std_logic_vector(7 downto 0);
	
begin
   DUT: CPU port map (Clk, Reset, pb, sw, reg_out);

	Reset <= '0';
	Clk<= not Clk after 100 ns;
	pb <= '0';
	sw <= "00000001";

end architecture Struct;