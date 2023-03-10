library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity veriyolu is 
	port (
			clk : in std_logic;
			rst : in std_logic;
			IR_Load : in std_logic; ----komut register i yükle kontrol
			MAR_Load : in std_logic;
			PC_Load : in std_logic;
			PC_Inc : in std_logic;
			A_Load : in std_logic;
			B_Load : in std_logic;
			ALU_Sel : in std_logic_vector(2 downto 0);
			CCR_Load : in std_logic;
			BUS1_sel : in std_logic_vector(1 downto 0);
			BUS2_sel : in std_logic_vector(1 downto 0);
			from_memory : in std_logic_vector(7 downto 0);
			--------Outputs
			IR : out std_logic_vector(7 downto 0);
			address : out std_logic_vector(7 downto 0); ---belleðe giden adres bilgisi
			CCR_Result : out std_logic_vector(3 downto 0); ---- NZVC
			to_memory : out std_logic_vector (7 downto 0) ----belleðe giden veri
			
		);
		end veriyolu;
		
		architecture arch of veriyolu is
		component ALU is
	port(
			A 			: in std_logic_vector (7 downto 0);
			B 			: in std_logic_vector (7 downto 0);
			ALU_Sel 	: in std_logic_vector (2 downto 0);
			---OUTPUT
			NZVC 		: out std_logic_vector(3 downto 0);
			ALU_result 	: out std_logic_vector(7 downto 0)

);
end component;

----veriyolu ic sinyalleri
signal 	BUS1 : std_logic_vector (7 downto 0);
signal 	BUS2 : std_logic_vector (7 downto 0);
signal ALU_result : std_logic_vector (7 downto 0);
signal 	IR_reg : std_logic_vector (7 downto 0);
signal 	MAR : std_logic_vector (7 downto 0);
signal 	PC : std_logic_vector (7 downto 0);
signal 	A_reg : std_logic_vector (7 downto 0);
signal 	B_reg : std_logic_vector (7 downto 0);
signal 	CCR_in : std_logic_vector (3 downto 0);
signal 	CCR : std_logic_vector (3 downto 0);


begin

--BUS MUX:
	BUS1 <= PC when BUS1_sel <= "00" else
			A_reg when BUS1_sel <= "01" else
			B_reg when BUS1_sel <= "10" else (others => '0');
			
	BUS2 <= ALU_result when BUS2_sel <= "00" else
			BUS1 when BUS2_sel <= "01" else
			from_memory when BUS2_sel <= "10" else (others => '0');		
			
---- KOMUT REGLER IR
	process(clk, rst)
	begin 
		if(rst = '1') then
			IR_reg <= x"00";
			elsif(rising_edge(clk))then
				if(IR_Load ='1') then
					IR_reg <= BUS2;
				end if;
			end if;
	end process;
	IR <= IR_reg;
---- memory reg ar
	process(clk, rst)
	begin 
		if(rst = '1') then
			MAR <= x"00";
			elsif(rising_edge(clk))then
				if(MAR_Load ='1') then
					MAR <= BUS2;
				end if;
			end if;
	end process;			
		address <= MAR;
		---- pc program counter
	process(clk, rst)
	begin 
		if(rst = '1') then
			PC <= x"00";
			elsif(rising_edge(clk))then
				if(PC_Load ='1') then
					PC <= BUS2;
					elsif (PC_Inc = '1') then
						PC <= PC + x"01";
				end if;
			end if;
	end process;
	---- A reg
	process(clk, rst)
	begin 
		if(rst = '1') then
			A_reg <= x"00";
			elsif(rising_edge(clk))then
				if(A_Load ='1') then
					A_reg <= BUS2;
				end if;
			end if;
	end process;
	---- B reg
	process(clk, rst)
	begin 
		if(rst = '1') then
			B_reg <= x"00";
			elsif(rising_edge(clk))then
				if(B_Load ='1') then
					B_reg <= BUS2;
				end if;
			end if;
	end process;
---ALU

	ALU_U: ALU port map (
			A 			=> B_reg,
			B 			=> BUS2,
			ALU_Sel 	=> ALU_Sel,
			---OUTPUT   => 
			NZVC 		=> CCR_in,
			ALU_result 	=> ALU_result
);

---- ccr
	process(clk, rst)
	begin 
		if(rst = '1') then
			CCR <= x"00";
			elsif(rising_edge(clk))then
				if(CCR_Load ='1') then
					CCR <= CCR_in; ---NZVC FLAG BILGISI
					
				end if;
			end if;
	end process;
	CCR_Result <= CCR;
	
	---- VERÝYOLUNDAN BELLEÐE GÝDÝCEK OLAN SÝNYAL
		to_memory <= BUS1;








		
		
		
		
		
		end architecture;