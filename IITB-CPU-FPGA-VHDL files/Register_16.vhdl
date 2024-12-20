library ieee;
use ieee.std_logic_1164.all;

entity Register_16 is
   port(clk, rw, reset: in std_logic; 
			data_in: in std_logic_vector(15 downto 0);
			data_out: out std_logic_vector(15 downto 0));
end entity;

architecture struct of Register_16 is	
	signal reg_data: std_logic_vector(15 downto 0):="0000000000000000";
	
	begin
	
	clk_proc: process(clk,data_in, rw, reset)
		begin
		if (reset='1') then
			reg_data <= "0000000000000000";
		else
			if (rw='1') then
				if (clk'event and clk='1') then
					reg_data <= data_in;
				else
				end if;
			else
			end if;
		end if;
	end process;
	
	data_out <= reg_data;
	
end struct;