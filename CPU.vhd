library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity CPU is
	port (
			clk : in std_logic;
			rst : in std_logic;
			from_memory : in std_logic_vector (7 downto 0);
			--output
			address : out std_logic_vector (7 downto 0);
			to_memory : out std_logic_vector (7 downto 0);
			write_en : out std_logic
);
end CPU;

architecture arch of CPU is
-----Control Unit
component control_unit is
	port(
			clk			: in std_logic;
			rst			: in std_logic;
			CCR_Result	: in std_logic_vector(3 downto 0);
			IR			: in std_logic_vector(7 downto 0);
			-- Outputlar:
			IR_Load		: out std_logic;	-- Komut register'i yükle kontrol
			MAR_Load 	: out std_logic;
			PC_Load 	: out std_logic;
			PC_Inc 		: out std_logic;
			A_Load 		: out std_logic;
			B_Load 		: out std_logic;
			ALU_Sel 	: out std_logic_vector(2 downto 0);
			CCR_Load 	: out std_logic;
			BUS1_Sel	: out std_logic_vector(1 downto 0);
			BUS2_Sel	: out std_logic_vector(1 downto 0);
			write_en	: out std_logic

	);
end component;


-----veriyolu
component veriyolu is 
	port (
			clk 		: in std_logic;
			rst 		: in std_logic;
			IR_Load 	: in std_logic; ----komut register i yükle kontrol
			MAR_Load 	: in std_logic;
			PC_Load 	: in std_logic;
			PC_Inc 		: in std_logic;
			A_Load 		: in std_logic;
			B_Load 		: in std_logic;
			ALU_Sel 	: in std_logic_vector(2 downto 0);
			CCR_Load 	: in std_logic;
			BUS1_sel : in std_logic_vector(1 downto 0);
			BUS2_sel : in std_logic_vector(1 downto 0);
			From_memory : in std_logic_vector(7 downto 0);
			--------Outputs
			IR 			: out std_logic_vector(7 downto 0);
			address		: out std_logic_vector(7 downto 0); ---belleðe giden adres bilgisi
			CCR_Result 	: out std_logic_vector(3 downto 0); ---- NZVC
			to_memory 	: out std_logic_vector (7 downto 0) ----belleðe giden veri
			
		);
		end component;
--- Baðlantý Sinyalleri

signal IR_Load		: std_logic;	-- Komut register'i yükle kontrol
signal IR			: std_logic_vector(7 downto 0);
signal MAR_Load 	: std_logic;
signal PC_Load 		: std_logic;
signal PC_Inc 		: std_logic;
signal A_Load 		: std_logic;
signal B_Load 		: std_logic;
signal ALU_Sel 		: std_logic_vector(2 downto 0);
signal CCR_Load 	: std_logic;
signal CCR_Result	: std_logic_vector(3 downto 0);	
signal BUS1_Sel		: std_logic_vector(1 downto 0);
signal BUS2_Sel		: std_logic_vector(1 downto 0);






begin
---Control Unit Port map
control_unit_module: control_unit port map 
(

clk					=> clk ,
rst			        => rst,
CCR_Result	        => CCR_Result,	
IR			        => IR,
---  Outputlar     
IR_Load		        => IR_Load,		
MAR_Load 	        => MAR_Load, 	
PC_Load 	        => PC_Load, 	
PC_Inc 		        => PC_Inc ,		
A_Load 		        => A_Load ,		
B_Load 		        => B_Load ,		
ALU_Sel 	        => ALU_Sel, 	
CCR_Load 	        => CCR_Load ,	
BUS1_Sel	        => BUS1_Sel	,
BUS2_Sel	        => BUS2_Sel	,
write_en	        => write_en	




);

----VERIYOLU
veriyolu_module : veriyolu port map (
clk 			=> clk,
rst 		    => rst,
IR_Load 	    => IR_Load ,	
MAR_Load 	    => MAR_Load ,	
PC_Load 	    => PC_Load 	,
PC_Inc 		    => PC_Inc 	,	
A_Load 		    => A_Load 	,	
B_Load 		    => B_Load 	,	
ALU_Sel 	    => ALU_Sel 	,
CCR_Load 	    => CCR_Load ,	
BUS1_sel     => BUS1_sel,
BUS2_sel     => BUS2_sel,
From_memory     => From_memory,
--------Outp    =>
IR 			    => IR 			,
address		    => address		,
CCR_Result 	    => CCR_Result,
to_memory 	    => to_memory 

);









end architecture;

