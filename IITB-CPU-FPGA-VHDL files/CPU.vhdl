library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
	port(Clk, reset, pb: in std_logic;
			sw: in std_logic_vector(7 downto 0);
			reg_out: out std_logic_vector(7 downto 0));
end entity;

architecture struct of CPU is
	component Register_16 is
		port(clk, rw, reset: in std_logic; 
			data_in: in std_logic_vector(15 downto 0);
			data_out: out std_logic_vector(15 downto 0));
	end component;
	
	component Reg_file is
		port(RF_A1,RF_A2,RF_A3: in std_logic_vector(2 downto 0);
			RF_D3: in std_logic_vector(15 downto 0);
			rw, Clk, reset: in std_logic;
			RF_D1,RF_D2, RF_D4: out std_logic_vector(15 downto 0);
			RF_OUT0, RF_OUT1, RF_OUT2, RF_OUT3, RF_OUT4, RF_OUT5, RF_OUT6, RF_OUT7: out std_logic_vector(15 downto 0));
	end component;
	
	component ALU is
		port (A: in std_logic_vector(15 downto 0);
				B: in std_logic_vector(15 downto 0);
				state: in std_logic_vector(4 downto 0);
				C: out std_logic_vector(15 downto 0);
				Z: out std_logic
				);
	end component;
	
	component FSM is
		port(Clk, reset: in std_logic;
			opcode: in std_logic_vector(3 downto 0);
			state: out integer);
	end component;
	
	component data_path is
    port(state : in integer;alu_z: in std_logic; m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,mw,ir_w,rf_w,t1_w,t2_w,t3_w : out std_logic);
	end component;
	
	component Memory is 
	port (add,data_in: in std_logic_vector(15 downto 0); 
			clk,rw: in std_logic;
			data_out: out std_logic_vector(15 downto 0));
	end component;

---------------------------------------------------------------------------------------
	component mux8_1_16bit is 
		port(A,B,C,D,E,F,G,H: in std_logic_vector(15 downto 0); sel0,sel1,sel2: in std_logic; Y: out std_logic_vector(15 downto 0));
	end component;
	
	component mux8_1_3bit is
		port(A,B,C,D,E,F,G,H: in std_logic_vector(2 downto 0); sel0,sel1,sel2: in std_logic; Y: out std_logic_vector(2 downto 0));
	end component;
	
	component mux8_1 is 
		port(A, B, C, D, E, F, G, H,sel0, sel1, sel2: in std_logic;Y: out std_logic);
	end component;
	
	component mux4_1_16bit is 
		port(A,B,C,D: in std_logic_vector(15 downto 0); sel0,sel1: in std_logic; Y: out std_logic_vector(15 downto 0));
	end component;
	
	component mux4_1_3bit is 
		port(A,B,C,D: in std_logic_vector(2 downto 0); sel0,sel1: in std_logic; Y: out std_logic_vector(2 downto 0));
	end component;
	
	component mux4_1 is 
		port(A,B,C,D,sel0,sel1: in std_logic; Y: out std_logic);
	end component;
	
	component mux2_1_16bit is 
		port(A,B: in std_logic_vector(15 downto 0); sel: in std_logic; Y: out std_logic_vector(15 downto 0));
	end component;
	
	component mux2_1_3bit is 
		port(A,B: in std_logic_vector(2 downto 0); sel: in std_logic; Y: out std_logic_vector(2 downto 0));
	end component;
	
	component mux2_1 is 
		port(A,B,sel: in std_logic; Y: out std_logic);
	end component;
---------------------------------------------------------------------------------------

	component concat1 is
		port (A: in std_logic_vector(7 downto 0);
				C: out std_logic_vector(15 downto 0));
	end component;
	
	component concat2 is
		port (A: in std_logic_vector(7 downto 0);
				C: out std_logic_vector(15 downto 0));
	end component;
	
	component sign_ext_9to16 is
		port (A: in std_logic_vector(8 downto 0);
				C: out std_logic_vector(15 downto 0));
	end component;
	
	component sign_ext_6to16 is
		port (A: in std_logic_vector(5 downto 0);
				C: out std_logic_vector(15 downto 0));
	end component;
---------------------------------------------------------------------------------------
	signal IR_out, mem_out, RF_D1, RF_D2, RF_D4 : std_logic_vector(15 downto 0);
	signal M1_out, M45_out, M67_out, M89_out, M1011_out: std_logic_vector(15 downto 0);
	signal M23_out: std_logic_vector(2 downto 0);
	signal ALU_C, T1_out, T2_out, T3_out, sign_ext9_out, sign_ext6_out, concat1_out, concat2_out: std_logic_vector(15 downto 0);
	signal IR_W, T1_W, T2_W, T3_W, RF_W, MW: std_logic;
	signal M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12, ALU_Z: std_logic;
	signal state: integer;
	signal state_5: std_logic_vector(4 downto 0);
	signal Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7: std_logic_vector(15 downto 0);
	begin
	
	FSM_instance: FSM port map (clk,Reset,IR_out(15 downto 12), state);
	Datapath_instance: data_path port map(state, ALU_Z, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12, MW, IR_W, RF_W, T1_W, T2_W, T3_W); 
	-- Naming convention: Mux x ==> inputs Mx_0,Mx_1,etc; output Mx_out; control signal Mx
		
	Memory_inst: Memory port map (M1_out, T1_out, Clk, MW, mem_out);
	IR: Register_16 port map (clk, IR_W, reset, mem_out, IR_out);
	Register_file: Reg_file port map (IR_out(11 downto 9), IR_out(8 downto 6), M23_out, M45_out, RF_W, Clk, reset, RF_D1, RF_D2, RF_D4, Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, Reg7);
	state_5 <= std_logic_vector(to_unsigned(state, 5));
	ALU_inst: ALU port map (M67_out, M89_out, state_5, ALU_C, ALU_Z);
	
	T1: Register_16 port map (clk, T1_W, reset, RF_D1, T1_out);
	T2: Register_16 port map (clk, T2_W, reset, RF_D2, T2_out);
	T3: Register_16 port map (clk, T3_W, reset, M1011_out, T3_out);
	
	Sign_extend1: sign_ext_9to16 port map (IR_out(8 downto 0), sign_ext9_out);
	Sign_extend2: sign_ext_6to16 port map (IR_out(5 downto 0), sign_ext6_out);
	Concat_msb: concat1 port map (IR_out(7 downto 0), concat1_out);
	Concat_lsb: concat2 port map (IR_out(7 downto 0), concat2_out);
	
	M1_inst: mux2_1_16bit port map (RF_D4, T3_out, M1, M1_out);
	M23_inst: mux4_1_3bit port map ("111", IR_out(5 downto 3), IR_out(8 downto 6), IR_out(11 downto 9), M2, M3, M23_out);
	M4512_inst: mux8_1_16bit port map (T3_out, concat1_out, concat2_out, RF_D4, mem_out, mem_out, mem_out, mem_out,M4, M5, M12, M45_out);
	M67_inst: mux4_1_16bit port map (RF_D4, T1_out, T2_out, T3_out, M6, M7, M67_out);
	M89_inst: mux4_1_16bit port map ("0000000000000001", T2_out, sign_ext6_out, sign_ext9_out, M8, M9, M89_out);
	M1011_inst: mux4_1_16bit port map (ALU_C, RF_D2, RF_D4, RF_D4, M10, M11, M1011_out);
	
--	IR_final<= IR_out;
--	state_final<=state;
	
--	Reg0_out<= Reg0;
--	Reg1_out<= Reg1;
--	Reg2_out<= Reg2;
--	Reg3_out<= Reg3;
--	Reg4_out<= Reg4;
--	Reg5_out<= Reg5;
--	Reg0_out<= Reg0(6 downto 0);
--	Reg7_out<= Reg7;
	
---	M67_outie<=M67_out;
--	M89_outie<=M89_out;
--	mem_outie<=mem_out;
--	T3_outie<=T3_out;

	
	reg_out(0) <= (Reg0(8) and sw(0) and pb) or (Reg1(8) and sw(1) and pb) or (Reg2(8) and sw(2) and pb) or (Reg3(8) and sw(3) and pb) or (Reg4(8) and sw(4) and pb) or (Reg5(8) and sw(5) and pb) or (Reg6(8) and sw(6) and pb) or (Reg7(8) and sw(7) and pb) or (Reg0(0) and sw(0) and (not pb)) or (Reg1(0) and sw(1) and (not pb)) or (Reg2(0) and sw(2) and (not pb)) or (Reg3(0) and sw(3) and (not pb)) or (Reg4(0) and sw(4) and (not pb)) or (Reg5(0) and sw(5) and (not pb)) or (Reg6(0) and sw(6) and (not pb)) or (Reg7(0) and sw(7) and (not pb));
	reg_out(1) <= (Reg0(9) and sw(0) and pb) or (Reg1(9) and sw(1) and pb) or (Reg2(9) and sw(2) and pb) or (Reg3(9) and sw(3) and pb) or (Reg4(9) and sw(4) and pb) or (Reg5(9) and sw(5) and pb) or (Reg6(9) and sw(6) and pb) or (Reg7(9) and sw(7) and pb) or (Reg0(1) and sw(0) and (not pb)) or (Reg1(1) and sw(1) and (not pb)) or (Reg2(1) and sw(2) and (not pb)) or (Reg3(1) and sw(3) and (not pb)) or (Reg4(1) and sw(4) and (not pb)) or (Reg5(1) and sw(5) and (not pb)) or (Reg6(1) and sw(6) and (not pb)) or (Reg7(1) and sw(7) and (not pb));
	reg_out(2) <= (Reg0(10) and sw(0) and pb) or (Reg1(10) and sw(1) and pb) or (Reg2(10) and sw(2) and pb) or (Reg3(10) and sw(3) and pb) or (Reg4(10) and sw(4) and pb) or (Reg5(10) and sw(5) and pb) or (Reg6(10) and sw(6) and pb) or (Reg7(10) and sw(7) and pb) or (Reg0(2) and sw(0) and (not pb)) or (Reg1(2) and sw(1) and (not pb)) or (Reg2(2) and sw(2) and (not pb)) or (Reg3(2) and sw(3) and (not pb)) or (Reg4(2) and sw(4) and (not pb)) or (Reg5(2) and sw(5) and (not pb)) or (Reg6(2) and sw(6) and (not pb)) or (Reg7(2) and sw(7) and (not pb));
	reg_out(3) <= (Reg0(11) and sw(0) and pb) or (Reg1(11) and sw(1) and pb) or (Reg2(11) and sw(2) and pb) or (Reg3(11) and sw(3) and pb) or (Reg4(11) and sw(4) and pb) or (Reg5(11) and sw(5) and pb) or (Reg6(11) and sw(6) and pb) or (Reg7(11) and sw(7) and pb) or (Reg0(3) and sw(0) and (not pb)) or (Reg1(3) and sw(1) and (not pb)) or (Reg2(3) and sw(2) and (not pb)) or (Reg3(3) and sw(3) and (not pb)) or (Reg4(3) and sw(4) and (not pb)) or (Reg5(3) and sw(5) and (not pb)) or (Reg6(3) and sw(6) and (not pb)) or (Reg7(3) and sw(7) and (not pb));
	reg_out(4) <= (Reg0(12) and sw(0) and pb) or (Reg1(12) and sw(1) and pb) or (Reg2(12) and sw(2) and pb) or (Reg3(12) and sw(3) and pb) or (Reg4(12) and sw(4) and pb) or (Reg5(12) and sw(5) and pb) or (Reg6(12) and sw(6) and pb) or (Reg7(12) and sw(7) and pb) or (Reg0(4) and sw(0) and (not pb)) or (Reg1(4) and sw(1) and (not pb)) or (Reg2(4) and sw(2) and (not pb)) or (Reg3(4) and sw(3) and (not pb)) or (Reg4(4) and sw(4) and (not pb)) or (Reg5(4) and sw(5) and (not pb)) or (Reg6(4) and sw(6) and (not pb)) or (Reg7(4) and sw(7) and (not pb));
	reg_out(5) <= (Reg0(13) and sw(0) and pb) or (Reg1(13) and sw(1) and pb) or (Reg2(13) and sw(2) and pb) or (Reg3(13) and sw(3) and pb) or (Reg4(13) and sw(4) and pb) or (Reg5(13) and sw(5) and pb) or (Reg6(13) and sw(6) and pb) or (Reg7(13) and sw(7) and pb) or (Reg0(5) and sw(0) and (not pb)) or (Reg1(5) and sw(1) and (not pb)) or (Reg2(5) and sw(2) and (not pb)) or (Reg3(5) and sw(3) and (not pb)) or (Reg4(5) and sw(4) and (not pb)) or (Reg5(5) and sw(5) and (not pb)) or (Reg6(5) and sw(6) and (not pb)) or (Reg7(5) and sw(7) and (not pb));
	reg_out(6) <= (Reg0(14) and sw(0) and pb) or (Reg1(14) and sw(1) and pb) or (Reg2(14) and sw(2) and pb) or (Reg3(14) and sw(3) and pb) or (Reg4(14) and sw(4) and pb) or (Reg5(14) and sw(5) and pb) or (Reg6(14) and sw(6) and pb) or (Reg7(14) and sw(7) and pb) or (Reg0(6) and sw(0) and (not pb)) or (Reg1(6) and sw(1) and (not pb)) or (Reg2(6) and sw(2) and (not pb)) or (Reg3(6) and sw(3) and (not pb)) or (Reg4(6) and sw(4) and (not pb)) or (Reg5(6) and sw(5) and (not pb)) or (Reg6(6) and sw(6) and (not pb)) or (Reg7(6) and sw(7) and (not pb));
	reg_out(7) <= (Reg0(15) and sw(0) and pb) or (Reg1(15) and sw(1) and pb) or (Reg2(15) and sw(2) and pb) or (Reg3(15) and sw(3) and pb) or (Reg4(15) and sw(4) and pb) or (Reg5(15) and sw(5) and pb) or (Reg6(15) and sw(6) and pb) or (Reg7(15) and sw(7) and pb) or (Reg0(7) and sw(0) and (not pb)) or (Reg1(7) and sw(1) and (not pb)) or (Reg2(7) and sw(2) and (not pb)) or (Reg3(7) and sw(3) and (not pb)) or (Reg4(7) and sw(4) and (not pb)) or (Reg5(7) and sw(5) and (not pb)) or (Reg6(7) and sw(6) and (not pb)) or (Reg7(7) and sw(7) and (not pb));
	
	

end struct;