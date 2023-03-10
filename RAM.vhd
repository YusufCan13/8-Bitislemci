library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity ram is 
		port(
		----in portlar
		address : in std_logic_vector(7 downto 0);
		data_in : in std_logic_vector(7 downto 0);
		write_en : in std_logic; ----cpu tarafından gönderilen yaz komutu
		clk : in std_logic;
		----- output
		data_out : out std_logic_vector(7 downto 0)
		);
		end ram;
		
		architecture arch of ram is 
		
		type ram_type is array (128 to 223) of std_logic_vector(7 downto 0); ----96x8 bit
		signal ram : ram_type := (others => x"00" ); ---- başlangıç verilerinin hepsi 0
		signal enable : std_logic;
		
		begin 
		process(address)
		begin
			if(address >= x"80" and address <= x"DF") then ----128 İLE 223 aralığında ise
				enable <= '1';
			else
				enable <= '0';
			end if;
		end process;
		process(clk)
			 begin
			 if(rising_edge(clk)) then
			 
					if (enable = '1' and write_en = '1' )then
						ram(to_integer(unsigned(address))) <=data_in;  
					end if;
					elsif(enable ='1' and write_en = '0')then
					data_out <= ram(to_integer(unsigned(address)));
				
				end if;
					end process;
		
		end architecture;