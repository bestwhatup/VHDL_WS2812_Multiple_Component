library ieee;
use ieee.std_logic_1164.all;

entity PWM_LED is
	port (
			 CLK : in std_logic;
			 Color_Data_in : in std_logic_vector(0 to 23);
			 Number_Led_in : in std_logic_vector(3 downto 0);
			 Data_PWM_out : out std_logic
		);
end PWM_LED;

architecture behavior of PWM_LED is
	-- constant time variable
	constant fpga_clk : integer := 50_000_000;
	constant T0H : time := 360 ns;
	constant T0L : time := 800 ns;
	constant T1H : time := 700 ns;
	constant T1L : time := 600 ns;
	constant Reset : time := 50 us;
	
	constant time_per_clk : time := (1 sec/fpga_clk);
	
	constant T0H_per_clk : integer := (T0H/time_per_clk); -- 20 cycle
	constant T0L_per_clk : integer := (T0L/time_per_clk); -- 40 cycle
	constant T1H_per_clk : integer := (T1H/time_per_clk); -- 35 cycle
	constant T1L_per_clk : integer := (T1L/time_per_clk); -- 30 cycle
	constant Reset_per_clk : integer := (Reset/time_per_clk); --2550 cycle
	
	 --init signal variable
	type state_type is(S0,S1,S2);
	
	begin
		process(CLK)
			--count clk for pb
			variable count_clk : integer := 0;
			variable color_bit_count : integer := 0;
			
			variable send_color_1bit_is_done : bit := '0';
			variable send_color_24bit_is_done : bit := '0';
		
			variable send_bit_status : state_type := S2;
			-- temp variable of color data
			variable temp_color_data : std_logic_vector(0 to 23);
			
			variable nLED : integer := 0;
			variable counter_LED_sent : integer := 0;
			
			begin
				if rising_edge(CLK) then
					count_clk := count_clk + 1;
					
				case Number_Led_in is
					when "0000" => nLED := 0;
					when "0001" => nLED := 1;
					when "0010" => nLED := 2;
					when "0011" => nLED := 3;
					when "0100" => nLED := 4;
					when "0101" => nLED := 5;
					when "0110" => nLED := 6;
					when "0111" => nLED := 7;
					when "1000" => nLED := 8;
					when "1001" => nLED := 9;
					when "1010" => nLED := 10;
					when "1011" => nLED := 11;
					when "1100" => nLED := 12;
					when "1101" => nLED := 13;
					when "1110" => nLED := 14;
					when "1111" => nLED := 15;
					when others => null;
				end case;

				--fix nLED = 0
				if nLED = 0 then
					send_bit_status := S2;
				end if;
				
				--check send < 23 bit and status isn't wait reset code of device
				if color_bit_count < 23 and send_bit_status /= S2 then
					if send_color_1bit_is_done = '1' then
						send_color_1bit_is_done := '0';
						--recheck
						if send_color_24bit_is_done = '1' then
							color_bit_count := 0;
							send_color_24bit_is_done := '0';
						else
							color_bit_count := color_bit_count + 1;
						end if;
						--get 1 bit from Color Data (update)
						if (Color_Data_in(color_bit_count) = '0') then
							send_bit_status := S0;
						elsif(Color_Data_in(color_bit_count) = '1') then
							send_bit_status := S1;
						end if;
						
					else
						----get 1 bit from Color Data (update)
						if (Color_Data_in(color_bit_count) = '0') then
							send_bit_status := S0;
						elsif(Color_Data_in(color_bit_count) = '1') then
							send_bit_status := S1;
						end if;
					end if;
				end if;
				
				if temp_color_data /= Color_Data_in then
					temp_color_data := Color_Data_in;
					color_bit_count := 0;
					count_clk := 0;
					if (Color_Data_in(color_bit_count) = '0') then
						send_bit_status := S0;
					elsif(Color_Data_in(color_bit_count) = '1') then
						send_bit_status := S1;
					end if;
				end if;
				
			-- State for send bit
			case send_bit_status is
						when S0 =>
							if count_clk <= (T0H_per_clk+T0l_per_clk) then
								if count_clk < T0H_per_clk then
									Data_PWM_out <= '1';
								else
									Data_PWM_out <= '0';
								end if;
							else
								--if send 24 bit susscess
								if color_bit_count = 23 then
									counter_LED_sent := counter_LED_sent + 1;
									if counter_LED_sent = nLED then
										send_color_24bit_is_done := '1';
										send_color_1bit_is_done := '1';
										send_bit_status := S2;
										color_bit_count := 0;
										count_clk := 0;
										counter_LED_sent := 0;
									else
										color_bit_count := -1;
										count_clk := 0;
										send_color_1bit_is_done := '1';
									end if;
								else
									count_clk := 0;
									send_color_1bit_is_done := '1';
								end if ;
							end if;
							
						when S1 =>
							if count_clk <= (T1H_per_clk+T1L_per_clk) then
								if count_clk < T1H_per_clk then
									Data_PWM_out <= '1';
								else
									Data_PWM_out <= '0';
								end if;
							else
								--if send 24 bit susscess
								if color_bit_count = 23 then
									counter_LED_sent := counter_LED_sent + 1;
									if counter_LED_sent = nLED then
										send_color_24bit_is_done := '1';
										send_color_1bit_is_done := '1';
										send_bit_status := S2;
										color_bit_count := 0;
										count_clk := 0;
										counter_LED_sent := 0;
									else
										color_bit_count := -1;
										count_clk := 0;
										send_color_1bit_is_done := '1';
									end if;
								else
									count_clk := 0;
									send_color_1bit_is_done := '1';
								end if ;
							end if;
						-- State wait reset code of device
						when S2 =>
							Data_PWM_out <= '0';
						when others => null;
					end case;
			
					
				end if;
		end process;
end behavior;