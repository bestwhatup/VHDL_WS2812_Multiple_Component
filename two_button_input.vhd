library ieee;
use ieee.std_logic_1164.all;

entity two_button_input is
	port (
			CLK : in std_logic;
			PB : in std_logic;
			RST_B : in std_logic;
			Button_Output : out std_logic_vector(0 to 1)
	);
end two_button_input;

architecture behavior of two_button_input is
	
	type state_type is (S0,S1);
	signal state_PB : state_type := S0;
	signal state_RST : state_type := S0;
	
	begin	
	process(CLK)
		variable output_counter : integer := 0;
		begin
			if rising_edge(CLK) then
				case state_PB is
					when S0 =>
						if PB = '0' then
							state_PB <= S1;
						end if;
					when S1 =>
						if PB = '1' then
							if output_counter = 3 then
								output_counter := 0;
							else 
								output_counter := output_counter + 1;
							end if;
							
							case output_counter is
								when 0 => Button_Output <= "00";
								when 1 => Button_Output <= "01";
								when 2 => Button_Output <= "10";
								when 3 => Button_Output <= "11";
								when others => null;
							end case;
							state_PB <= S0;
						end if;
					when others => null;
				end case;
				
				case state_RST is
					when S0 =>
						if RST_B = '0' then
							state_RST <= S1;
						end if;
					when S1 =>
						if RST_B = '1' then
							output_counter := 0;
							Button_Output <= "00";
							state_RST <= S0;
						end if;
					when others => null;
				end case;
			end if;		
	end process;
end behavior;